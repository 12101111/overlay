#!/bin/bash

BASE_URL="https://commondatastorage.googleapis.com/chromium-browser-official/chromium-148.0.7778."

for version in $(seq 288 -1 218); do
    url="${BASE_URL}${version}.tar.xz"
    if curl -I -f -s -o /dev/null "$url"; then
        echo "available version: 148.0.7778.$version"
        echo "URL: $url"
        exit 0
    fi
done

echo "Can't find available version"
exit 1
