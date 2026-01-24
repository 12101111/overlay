#!/bin/bash

BASE_URL="https://commondatastorage.googleapis.com/chromium-browser-official/chromium-142.0.7444."

for version in $(seq 265 -1 175); do
    url="${BASE_URL}${version}.tar.xz"
    if curl -I -f -s -o /dev/null "$url"; then
        echo "available version: 142.0.7444.$version"
        echo "URL: $url"
        exit 0
    fi
done

echo "Can't find available version"
exit 1
