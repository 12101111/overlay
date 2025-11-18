#!/bin/bash

BASE_URL="https://commondatastorage.googleapis.com/chromium-browser-official/chromium-140.0.7339."

for version in $(seq 258 -1 207); do
    url="${BASE_URL}${version}.tar.xz"
    if curl -I -f -s -o /dev/null "$url"; then
        echo "available version: 140.0.7339.$version"
        echo "URL: $url"
        exit 0
    fi
done

echo "Can't find available version"
exit 1