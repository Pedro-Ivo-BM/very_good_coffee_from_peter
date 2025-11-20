#!/bin/bash

set -e

for dir in packages/*/; do
  echo "\n==> Processing $dir"
  cd "$dir" || continue
  flutter clean
  flutter pub get
  cd - > /dev/null
done

echo "\nAll packages cleaned and dependencies fetched!"
