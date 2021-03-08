#!/bin/sh

if [[ "${SKIP_SWIFTLINT}" == "YES" ]]; then
  exit 0
fi

if which swiftlint >/dev/null; then
  swiftlint --no-cache
else
  echo "warning: SwiftLint does not exist, download it from https://github.com/realm/SwiftLint"
fi
