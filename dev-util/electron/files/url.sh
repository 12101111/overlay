#!/bin/bash

BASE_URL="https://commondatastorage.googleapis.com/chromium-browser-official/chromium-150.0.7871."

for version in $(seq 260 -1 220); do
    url="${BASE_URL}${version}.tar.xz"
    if curl -I -f -s -o /dev/null "$url"; then
        echo "available version: 150.0.7871.$version"
        echo "URL: $url"
        exit 0
    fi
done

echo "Can't find available version"
exit 1
