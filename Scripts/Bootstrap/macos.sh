#!/bin/sh

readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

plain_version() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d", $1,$2,$3,$4); }'
}

echo "Checking ${macos_style}macOS${default_style} version:"

readonly macos_required_version='11.3.0'
readonly macos_version=$(/usr/bin/sw_vers -productVersion  2>&1)

if [ "$(plain_version ${macos_version})" -lt "$(plain_version ${macos_required_version})" ]; then
  echo "  ${error_style}Your macOS version (${macos_version}) is older then required version (${macos_required_version}). Exiting...${default_style}"
  exit 1
else
  echo "  Your macOS version: ${macos_version}"
fi

echo ""
