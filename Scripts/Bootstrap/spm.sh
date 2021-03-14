#!/bin/sh

readonly arguments=$@
readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

eval "$(swiftenv init -)"

if [[ " ${arguments[*]} " == *" ${update_flag} "* ]]; then
  echo "Updating ${spm_style}Swift packages${default_style} specified in Package.swift..."
  assert_failure '(cd "${root_path}" && swift package update)'
else
  echo "Resolving ${spm_style}Swift packages${default_style} specified in Package.swift..."
  assert_failure '(cd "${root_path}" && swift package resolve)'
fi

echo ""
