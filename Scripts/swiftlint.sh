#!/bin/sh

if [[ "${SKIP_SWIFTLINT}" == "YES" ]]; then
  exit 0
fi

readonly helpers_path="$( cd "$( dirname "$0" )" && pwd )/Helpers"

source "${helpers_path}/script-run.sh"
run swiftlint --quiet || true
