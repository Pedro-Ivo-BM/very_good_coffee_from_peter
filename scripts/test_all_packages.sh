#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

pushd "${REPO_ROOT}" > /dev/null

overall_status=0

for dir in packages/*/; do
  if [[ ! -d "${dir}" || ! -f "${dir}pubspec.yaml" ]]; then
    continue
  fi

  echo "\n==> Running tests in ${dir%/}"  
  if (cd "${dir}" && flutter test); then
    echo "Completed tests for ${dir%/}"
  else
    echo "Tests failed in ${dir%/}"
    overall_status=1
  fi

done

popd > /dev/null

exit ${overall_status}
