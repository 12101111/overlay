#!/usr/bin/env python3
"""Remove hunks from patch files which cannot be applied to a source tree.

The Chromium source tarball used by the electron ebuild does not ship every
file which Electron's bundled patches touch (web platform tests, v8 tests and
so on), and some hunks no longer match the sources.  Applying such a patch
with eapply(1) therefore fails, even though every remaining hunk of the patch
is perfectly fine.  Historically this was worked around by hand-maintaining a
patch which patched the patches.

This script does that step automatically.  It parses a patch into file
sections and hunks, simulates applying every hunk to the target tree with the
very same options that eapply(1) uses for Electron's patches
(-p1 -f -g0 --no-backup-if-mismatch), and rewrites the patch file without the
hunks which cannot be applied.

Only changes under the test directories listed in KNOWN_TEST_PREFIXES may be
dropped silently: the Chromium tarball strips those files, so failing hunks
there are expected.  A hunk outside of those directories which cannot be
applied (including one which is already applied) is an error, because dropping
it could hide a real problem; the build is aborted so the patch can be fixed
instead.

The script intentionally runs against the live tree, so it must be called
right before the patch is applied: later patches of a series may rely on
changes made by earlier ones.

Usage:
    prune-patch-hunks.py [options] PATCH [PATCH ...]

The patch is rewritten in place.  A patch whose changes have been removed
completely is truncated to an empty file, which patch(1) accepts as a no-op.
A patch containing a git binary diff is rejected, because patch(1) cannot
apply binary diffs and applying only its text parts could leave the tree in an
inconsistent state.

Exit status:
    0  every patch can be applied (possibly after dropping test files)
    1  error: an unappliable change outside of the test directories, an
       unparsable patch, a git binary diff, or an unexpected patch(1) failure

This program is free software, distributed under the terms of the GNU General
Public License version 2.
"""

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile

# Options which Gentoo's eapply() passes to patch(1) by default.
PATCH_OPTS = ["-f", "-g0", "--no-backup-if-mismatch"]

# Run patch(1) in the C locale so its diagnostics are stable.
PATCH_ENV = dict(os.environ, LC_ALL="C", LC_MESSAGES="C")

HUNK_RE = re.compile(rb"^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@")

# Directories which contain tests only.  Chromium's source tarball does not
# ship them, so hunks which touch these files are expected to fail and are
# dropped without a message.  Any other failing hunk aborts the build.
# Note: paths are relative to the repository the patch is applied to.
KNOWN_TEST_PREFIXES = (
    "content/test/",                    # chromium
    "src/tests/",                       # third_party/angle
    "test/",                            # v8
    "third_party/blink/web_tests/",     # chromium
)


class PatchError(Exception):
    """The patch file could not be parsed or applied."""


def split_lines(data):
    """Split *data* into lines, keeping the line endings byte for byte."""
    lines = data.split(b"\n")
    result = [line + b"\n" for line in lines[:-1]]
    if lines[-1]:
        result.append(lines[-1])
    return result


class Hunk:
    __slots__ = ("lines",)

    def __init__(self, lines):
        self.lines = lines


class Section:
    """One file section of a patch, e.g. everything for one 'diff --git'."""

    __slots__ = ("prefix", "old_line", "new_line", "hunks", "suffix")

    def __init__(self):
        self.prefix = []      # lines before the '---' line
        self.old_line = None
        self.new_line = None
        self.hunks = []
        self.suffix = []      # trailing lines which belong to no hunk

    def render(self, hunks=None):
        out = list(self.prefix)
        if self.old_line is not None:
            out.append(self.old_line)
        if self.new_line is not None:
            out.append(self.new_line)
        for hunk in (self.hunks if hunks is None else hunks):
            out.extend(hunk.lines)
        out.extend(self.suffix)
        return out

    @property
    def has_filenames(self):
        return self.old_line is not None and self.new_line is not None

    @property
    def header(self):
        return list(self.prefix) + [self.old_line or b"", self.new_line or b""]


def parse_hunk(lines, index):
    """Parse the hunk starting at *index*, return (Hunk, next_index)."""
    match = HUNK_RE.match(lines[index])
    if match is None:
        raise PatchError("malformed hunk header: %r" % lines[index])

    old_remaining = int(match.group(2)) if match.group(2) is not None else 1
    new_remaining = int(match.group(4)) if match.group(4) is not None else 1
    body = [lines[index]]
    index += 1
    count = len(lines)

    while old_remaining > 0 or new_remaining > 0:
        if index >= count:
            raise PatchError("unexpected end of file inside a hunk")
        line = lines[index]
        body.append(line)
        index += 1
        if line.startswith(b"\\"):          # "\ No newline at end of file"
            continue
        first = line[0:1]
        if first in (b" ", b"\n", b"\r", b""):
            old_remaining -= 1
            new_remaining -= 1
        elif first == b"-":
            old_remaining -= 1
        elif first == b"+":
            new_remaining -= 1
        else:
            raise PatchError("malformed line in hunk: %r" % line)

    # A trailing "\ No newline at end of file" usually belongs to the hunk.
    while index < count and lines[index].startswith(b"\\"):
        body.append(lines[index])
        index += 1
    return Hunk(body), index


def parse_patch(data):
    """Split *data* into (preamble, [Section])."""
    lines = split_lines(data)
    preamble = []
    sections = []
    current = None
    index = 0
    count = len(lines)

    def finish():
        nonlocal current
        if current is not None:
            sections.append(current)
            current = None

    while index < count:
        line = lines[index]

        starts_git = line.startswith(b"diff --git ")
        starts_plain = (
            line.startswith(b"--- ")
            and index + 1 < count
            and lines[index + 1].startswith(b"+++ ")
            and (current is None or current.has_filenames)
        )

        if starts_git or starts_plain:
            finish()
            current = Section()
            current.prefix.append(line)
            index += 1
            continue

        if current is None:
            preamble.append(line)
            index += 1
            continue

        if not current.has_filenames:
            if line.startswith(b"--- "):
                current.old_line = line
                index += 1
                if index < count and lines[index].startswith(b"+++ "):
                    current.new_line = lines[index]
                    index += 1
                continue
            current.prefix.append(line)
            index += 1
            continue

        if line.startswith(b"@@ "):
            if not current.has_filenames:
                raise PatchError("hunk without file names")
            hunk, index = parse_hunk(lines, index)
            current.hunks.append(hunk)
            continue

        current.suffix.append(line)
        index += 1

    finish()
    return preamble, sections


def unquote_c(text):
    """Unquote a git C-style quoted path."""
    out = []
    index = 0
    length = len(text)
    while index < length:
        char = text[index]
        if char == "\\" and index + 1 < length:
            nxt = text[index + 1]
            if nxt in '\\"':
                out.append(nxt)
                index += 2
            elif nxt == "t":
                out.append("\t")
                index += 2
            elif nxt == "n":
                out.append("\n")
                index += 2
            elif nxt == "r":
                out.append("\r")
                index += 2
            elif nxt in "01234567":
                digits = ""
                index += 1
                while index < length and len(digits) < 3 and text[index] in "01234567":
                    digits += text[index]
                    index += 1
                out.append(chr(int(digits, 8)))
            else:
                out.append(nxt)
                index += 2
        else:
            out.append(char)
            index += 1
    return "".join(out)


def filename_of(line, strip, what):
    """Return the repository-relative path a '---'/'+++' line refers to.

    Returns None for /dev/null.
    """
    rest = line[4:].rstrip(b"\r\n")
    if rest == b"/dev/null":
        return None
    if b"\t" in rest:                       # timestamp separator
        rest = rest.split(b"\t", 1)[0]
    text = rest.decode("utf-8", "surrogateescape")
    if text.startswith('"') and text.endswith('"') and len(text) >= 2:
        text = unquote_c(text[1:-1])
    parts = text.split("/")
    if len(parts) <= strip:
        raise PatchError(
            "%s line has fewer than %d leading path components: %r"
            % (what, strip + 1, text)
        )
    return "/".join(parts[strip:])


def run_patch(tree, data, strip, dry_run=False, reverse=False, fuzz=None):
    """Run patch(1) in *tree*, return (returncode, output)."""
    command = ["patch", "-p%d" % strip] + PATCH_OPTS
    if dry_run:
        command.append("--dry-run")
    if reverse:
        command.append("-R")
    if fuzz is not None:
        command.append("-F%d" % fuzz)
    try:
        proc = subprocess.run(
            command,
            cwd=tree,
            input=data,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            env=PATCH_ENV,
        )
    except OSError as exc:
        raise PatchError("cannot run patch(1): %s" % exc)
    return proc.returncode, proc.stdout


def materialize(scratch, repo, rel_paths):
    """Create a scratch tree with copies of the named repository files."""
    for rel in rel_paths:
        if rel is None:
            continue
        source = os.path.join(repo, rel)
        target = os.path.join(scratch, rel)
        parent = os.path.dirname(target)
        if parent:
            os.makedirs(parent, exist_ok=True)
        if os.path.isfile(source):
            shutil.copyfile(source, target)
        elif os.path.isdir(source):
            os.makedirs(target, exist_ok=True)


def section_paths(section, strip):
    old_rel = new_rel = None
    if section.old_line is not None:
        old_rel = filename_of(section.old_line, strip, "---")
    if section.new_line is not None:
        new_rel = filename_of(section.new_line, strip, "+++")
    return old_rel, new_rel


def section_status(section, repo, strip, scratch_root):
    """Return ('keep'|'drop', reason) for a whole file section."""
    if not section.hunks:
        # Metadata only (mode change, rename, binary diff, ...).  Leave it
        # alone; patch(1) will decide what to do with it.
        return "keep", "metadata only"

    try:
        old_rel, new_rel = section_paths(section, strip)
    except PatchError as exc:
        return "drop", str(exc)

    if old_rel is None and new_rel is None:
        return "keep", "no file names"

    if old_rel is None:                     # creation
        parent = os.path.dirname(new_rel)
        if parent and not os.path.isdir(os.path.join(repo, parent)):
            return "drop", "%s: parent directory does not exist" % new_rel
    else:
        if not os.path.lexists(os.path.join(repo, old_rel)):
            return "drop", "%s: file does not exist" % old_rel
        if new_rel is not None and old_rel != new_rel:
            if not os.path.lexists(os.path.join(repo, new_rel)):
                return "drop", "%s: file does not exist" % new_rel

    scratch = tempfile.mkdtemp(dir=scratch_root)
    try:
        materialize(scratch, repo, (old_rel, new_rel))
        data = b"".join(section.render())
        code, _output = run_patch(scratch, data, strip, dry_run=True)
        if code == 0:
            return "keep", ""
        # Is it perhaps already applied?  Then dropping it is safe, because
        # the tree already contains the changes of this section.
        reverse_scratch = tempfile.mkdtemp(dir=scratch_root)
        try:
            materialize(reverse_scratch, repo, (old_rel, new_rel))
            code, _output = run_patch(
                reverse_scratch, data, strip, dry_run=True, reverse=True, fuzz=0
            )
        finally:
            shutil.rmtree(reverse_scratch, ignore_errors=True)
        if code == 0:
            return "drop", "already applied"
        return "partial", ""
    finally:
        shutil.rmtree(scratch, ignore_errors=True)


def test_hunks(section, repo, strip, scratch_root):
    """Return the list of hunks which apply when applied one by one."""
    try:
        old_rel, new_rel = section_paths(section, strip)
    except PatchError:
        return []
    creation = old_rel is None
    deletion = new_rel is None
    if (creation or deletion) and len(section.hunks) > 1:
        # A single hunk usually creates or deletes the whole file.  Splitting
        # such a section would make the later hunks fail because the file has
        # already been created or deleted, so keep or drop it as a whole.
        return []

    kept = []
    scratch = tempfile.mkdtemp(dir=scratch_root)
    try:
        materialize(scratch, repo, (old_rel, new_rel))
        header = section.header
        for hunk in section.hunks:
            data = b"".join(header + hunk.lines)
            code, _output = run_patch(scratch, data, strip)
            if code == 0:
                kept.append(hunk)
            elif code > 1:
                raise PatchError(
                    "patch(1) failed unexpectedly (exit status %d)" % code
                )
    finally:
        shutil.rmtree(scratch, ignore_errors=True)
    return kept


def write_patch(path, data):
    """Write *data* to *path* atomically, preserving the file mode."""
    path = os.path.abspath(path)
    directory = os.path.dirname(path)
    try:
        mode = os.stat(path).st_mode & 0o7777
    except OSError as exc:
        raise PatchError("%s: %s" % (path, exc))
    descriptor, temporary = tempfile.mkstemp(prefix=".prune-", dir=directory)
    try:
        with os.fdopen(descriptor, "wb") as stream:
            stream.write(data)
        os.chmod(temporary, mode)
        os.replace(temporary, path)
    except OSError as exc:
        try:
            os.unlink(temporary)
        except OSError:
            pass
        raise PatchError("%s: %s" % (path, exc))


def describe(section, strip):
    try:
        old_rel, new_rel = section_paths(section, strip)
    except PatchError:
        return "<unparsable section>"
    return new_rel or old_rel or "<unknown>"


def is_test_path(rel_path):
    return rel_path is not None and any(
        rel_path == prefix.rstrip("/") or rel_path.startswith(prefix)
        for prefix in KNOWN_TEST_PREFIXES
    )


def is_test_section(section, strip):
    """Return True if every file a section touches lives in a test directory."""
    try:
        paths = [path for path in section_paths(section, strip) if path is not None]
    except PatchError:
        return False
    return bool(paths) and all(is_test_path(path) for path in paths)


def prune_patch(path, repo, strip, dry_run=False, verbose=False):
    """Prune *path*; return the number of dropped sections and hunks."""
    try:
        with open(path, "rb") as stream:
            data = stream.read()
    except OSError as exc:
        raise PatchError("%s: %s" % (path, exc))

    name = os.path.basename(path)
    if not data.strip():
        if verbose:
            print("[prune] %s: empty, nothing to do" % name, file=sys.stderr)
        return 0, 0

    # Fast path: the whole patch applies as-is, no need to look at hunks.
    code, output = run_patch(repo, data, strip, dry_run=True)
    if code == 0:
        if verbose:
            print("[prune] %s: applies cleanly" % name, file=sys.stderr)
        return 0, 0

    preamble, sections = parse_patch(data)
    if not sections:
        raise PatchError(
            "%s: no file sections found; refusing to modify an unparsable "
            "patch" % path
        )

    # patch(1) does not support git binary diffs.  Applying only the text
    # parts of such a patch could leave the tree in an inconsistent state, so
    # refuse to touch it.
    for section in sections:
        if b"GIT binary patch" in b"".join(section.prefix):
            raise PatchError(
                "%s: contains a git binary diff, which patch(1) cannot apply"
                % path
            )

    scratch_root = tempfile.mkdtemp(prefix="prune-hunks-")
    dropped_sections = []
    dropped_hunks = []
    try:
        for section in sections:
            status, reason = section_status(section, repo, strip, scratch_root)
            if status == "drop":
                dropped_sections.append((section, reason))
                continue
            if status == "keep":
                continue
            kept = test_hunks(section, repo, strip, scratch_root)
            if not kept:
                dropped_sections.append((section, "does not apply"))
            elif len(kept) != len(section.hunks):
                dropped_hunks.append((section, kept))
    finally:
        shutil.rmtree(scratch_root, ignore_errors=True)

    if not dropped_sections and not dropped_hunks:
        # The dry run failed but every section applies on its own.  This
        # should not happen; leave the patch alone and fail loudly.
        raise PatchError(
            "%s: patch(1) rejected the patch as a whole, but every section "
            "applies on its own" % path
        )

    # Changes may only disappear from test directories.  Everything else is
    # reported as an error so that a real mismatch cannot be hidden.
    unexpected = []
    for section, reason in dropped_sections:
        if not is_test_section(section, strip):
            unexpected.append("%s (%s)" % (describe(section, strip), reason))
    for section, kept in dropped_hunks:
        if not is_test_section(section, strip):
            unexpected.append(
                "%s (%d of %d hunk(s) not applicable)"
                % (
                    describe(section, strip),
                    len(section.hunks) - len(kept),
                    len(section.hunks),
                )
            )
    if unexpected:
        raise PatchError(
            "%s: refusing to drop changes outside of test directories:\n  %s"
            % (path, "\n  ".join(unexpected))
        )

    dropped_ids = {id(section) for section, _ in dropped_sections}
    replacements = {id(section): kept for section, kept in dropped_hunks}
    output_lines = list(preamble)
    kept_sections = 0
    for section in sections:
        if id(section) in dropped_ids:
            continue
        kept_sections += 1
        output_lines.extend(section.render(replacements.get(id(section))))

    # Without any file section the file would only contain mail headers,
    # which patch(1) refuses to parse.  An empty patch is a valid no-op.
    new_data = b"".join(output_lines) if kept_sections else b""

    # Sanity check: the pruned patch must apply cleanly to the real tree.
    if new_data:
        code, output = run_patch(repo, new_data, strip, dry_run=True)
        if code != 0:
            raise PatchError(
                "%s: pruned patch still does not apply:\n%s"
                % (path, output.decode("utf-8", "replace"))
            )

    if not dry_run:
        write_patch(path, new_data)
    if verbose:
        print(
            "[prune] %s: dropped %d test section(s), %d test hunk(s)"
            % (
                name,
                len(dropped_sections),
                sum(len(sec.hunks) - len(kept) for sec, kept in dropped_hunks),
            ),
            file=sys.stderr,
        )
        if not new_data:
            print(
                "[prune] %s: all changes removed, patch is now empty" % name,
                file=sys.stderr,
            )

    return len(dropped_sections), sum(
        len(s.hunks) - len(k) for s, k in dropped_hunks
    )


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Drop hunks which cannot be applied from patch files."
    )
    parser.add_argument(
        "--repo-root",
        default=os.getcwd(),
        help="source tree the patch is applied to (default: current directory)",
    )
    parser.add_argument(
        "-p",
        "--strip",
        type=int,
        default=1,
        help="path strip level, like patch -p (default: 1)",
    )
    parser.add_argument(
        "-n",
        "--dry-run",
        action="store_true",
        help="check the patch without modifying it",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="also report patches which apply cleanly and test files dropped",
    )
    parser.add_argument("patches", nargs="+", help="patch files to prune")
    args = parser.parse_args(argv)

    if not os.path.isdir(args.repo_root):
        parser.error("--repo-root %s is not a directory" % args.repo_root)
    repo = os.path.abspath(args.repo_root)

    status = 0
    for path in args.patches:
        try:
            prune_patch(path, repo, args.strip, args.dry_run, args.verbose)
        except PatchError as exc:
            print("[prune] error: %s" % exc, file=sys.stderr)
            status = 1
    return status


if __name__ == "__main__":
    sys.exit(main())
