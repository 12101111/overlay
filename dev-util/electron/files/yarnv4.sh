#!/bin/bash
yq -r '
  # All items
  .[] 
  | select(.resolution) 
  | .resolution 
  | capture("(?<pkg>@?[^@]+)@npm:(?<ver>[0-9][^ ]*)")
  | if .pkg | startswith("@") then
      # url with @
      (.pkg | split("/")) as $parts
      | "https://registry.npmjs.org/\(.pkg)/-/\($parts[1])-\(.ver).tgz -> \($parts[0])-\($parts[1])-\(.ver).tgz"
    else
      # url without @
      "https://registry.npmjs.org/\(.pkg)/-/\(.pkg)-\(.ver).tgz"
    end
' $1 | sort | uniq
