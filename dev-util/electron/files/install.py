#!/usr/bin/env python3
import hashlib
import re
import urllib.parse
import tarfile
import zipfile
import gzip
import io
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from os import path
import yaml

def make_hash(*args):
    """
    source: packages/yarnpkg-core/sources/hashUtils.ts
    """
    hash_obj = hashlib.sha512()

    acc = ""
    for arg in args:
        if isinstance(arg, str):
            acc += arg
        elif arg:
            if acc:
                hash_obj.update(acc.encode('utf-8'))
                acc = ""

            hash_obj.update(str(arg).encode('utf-8'))

    if acc:
        hash_obj.update(acc.encode('utf-8'))

    return hash_obj.hexdigest()


def make_ident(scope, name):
    """
    source: packages/yarnpkg-core/sources/structUtils.ts
    """
    if scope and scope.startswith("@"):
        raise ValueError("Invalid scope: don't prefix it with '@'")

    return {"identHash": make_hash(scope, name), "scope": scope, "name": name}


def make_locator(ident, reference):
    """
    source: packages/yarnpkg-core/sources/structUtils.ts
    """
    return {
        "identHash": ident["identHash"],
        "scope": ident["scope"],
        "name": ident["name"],
        "locatorHash": make_hash(ident["identHash"], reference),
        "reference": reference
    }


def parse_locator(string):
    """
    source: packages/yarnpkg-core/sources/structUtils.ts
    """
    locator = try_parse_locator(string)
    if not locator:
        raise ValueError(f"Invalid locator ({string})")

    return locator


LOCATOR_REGEX_STRICT = re.compile(r'^(?:@([^/]+?)\/)?([^@/]+?)(?:@(.+))$')


def try_parse_locator(string):
    """
    source: packages/yarnpkg-core/sources/structUtils.ts
    """
    match = LOCATOR_REGEX_STRICT.match(string)

    if not match:
        return None

    scope, name, reference = match.groups()

    if reference == "unknown":
        raise ValueError(f"Invalid reference ({string})")

    real_reference = reference if reference is not None else "unknown"

    return make_locator(make_ident(scope, name), real_reference)


def stringify_ident(ident):
    """
    source: packages/yarnpkg-core/sources/structUtils.ts
    """
    if ident["scope"] is not None:
        return f"@{ident['scope']}/{ident['name']}"
    else:
        return ident["name"]


def slugify_ident(ident):
    """
    source: packages/yarnpkg-core/sources/structUtils.ts
    """
    if ident["scope"] is not None:
        return f"@{ident['scope']}-{ident['name']}"
    else:
        return ident["name"]


TRAILING_COLON_REGEX = re.compile(r':$')
RANGE_REGEX = re.compile(
    r'^([^#:]*:)?((?:(?!::)[^#])*)(?:#((?:(?!::).)*))?(?:::(.*))?$')


def parse_range(range_str):
    """
    source: packages/yarnpkg-core/sources/structUtils.ts
    """
    match = RANGE_REGEX.match(range_str)
    if match is None:
        raise ValueError(f"Invalid range ({range_str})")

    protocol, source_part, selector_part, params_part = match.groups()

    if selector_part is not None:
        source = urllib.parse.unquote(source_part) if source_part else None
        selector = urllib.parse.unquote(
            selector_part) if selector_part else None
    else:
        source = None
        selector = urllib.parse.unquote(source_part) if source_part else None

    params = None
    if params_part is not None:
        params = urllib.parse.parse_qs(params_part)
        params = {k: v[0] if len(v) == 1 else v for k, v in params.items()}

    return {
        "protocol": protocol,
        "source": source,
        "selector": selector,
        "params": params,
    }


def slugify_locator(locator):
    """
    source: packages/yarnpkg-core/sources/structUtils.ts
    """
    parsed_range = parse_range(locator["reference"])
    protocol = parsed_range["protocol"]
    source = parsed_range["source"]
    human_version = parsed_range["selector"]

    if protocol is not None:
        human_protocol = TRAILING_COLON_REGEX.sub('', protocol)
    else:
        human_protocol = "exotic"

    if human_version is not None:
        human_reference = f"{human_protocol}-{human_version}"
    else:
        human_reference = f"{human_protocol}"

    hash_truncate = 10

    if source:
        slug = f"{slugify_ident(locator)}-{human_protocol}-{locator['locatorHash'][:hash_truncate]}"
    else:
        slug = f"{slugify_ident(locator)}-{human_reference}-{locator['locatorHash'][:hash_truncate]}"

    return slug

CHECKSUM_REGEX = re.compile(r'^(?:(?P<cacheKey>(?P<cacheVersion>[0-9]+)(?P<cacheSpec>.*))\/)?(?P<hash>.*)$')

def get_filename(locator, checksum):
    """
    source: packages/yarnpkg-core/sources/Cache.ts
    """
    match = CHECKSUM_REGEX.match(checksum)
    if not match or not match.groupdict():
        raise ValueError(f"Invalid checksum ({checksum})")
    
    groups = match.groupdict()
    content_checksum = groups['hash']
    significant_checksum = content_checksum[:10]
    return f"{slugify_locator(locator)}-{significant_checksum}.zip"


def get_source_filename(locator):
    parsed_range = parse_range(locator["reference"])
    source = parsed_range["source"]
    selector = parsed_range["selector"]
    if source:
        return get_source_filename(parse_locator(source))
    else:
        return f"{slugify_ident(locator)}-{selector}.tgz"


def tgz_to_zip(tgz_path, zip_path, ident):
    """
    source: packages/yarnpkg-core/sources/tgzUtils.ts
    """
    with open(tgz_path, 'rb') as f:
        tar_gz_data = f.read()

    tar_data = gzip.decompress(tar_gz_data)
    tar_stream = io.BytesIO(tar_data)
    zip_stream = io.BytesIO()

    with tarfile.open(fileobj=tar_stream, mode='r') as tar, zipfile.ZipFile(zip_stream, 'w', zipfile.ZIP_STORED) as zipf:
        for member in tar.getmembers():
            if member.isfile():
                rootdir, sep, rest = member.name.partition('/')
                new_name = f"node_modules/{ident}/{rest}"
                file_data = tar.extractfile(member)
                if file_data:
                    zipf.writestr(new_name, file_data.read())

    with open(zip_path, 'wb') as f:
        f.write(zip_stream.getvalue())


def load_yarn_lock(lock_path, src_dir, dest_dir):
    with open(lock_path, 'r', encoding='utf-8') as f:
        lock_content = f.read()

    lock = yaml.load(lock_content, yaml.Loader)
    futures = []
    with ThreadPoolExecutor() as executor:
        for dep in lock.keys():
            if "resolution" not in lock[dep].keys():
                continue
            if "checksum" not in lock[dep].keys():
                continue
            locator = parse_locator(lock[dep]["resolution"])
            src_name = get_source_filename(locator)
            dest_name = get_filename(locator, lock[dep]["checksum"])
            fut = executor.submit(tgz_to_zip, f"{src_dir}/{src_name}", f"{dest_dir}/{dest_name}", stringify_ident(locator))
            futures.append(fut)

        for fut in as_completed(futures):
            exception = fut.exception()
            if exception is not None:
                print(exception)




if __name__ == "__main__":
    load_yarn_lock(sys.argv[1], sys.argv[2], sys.argv[3])
