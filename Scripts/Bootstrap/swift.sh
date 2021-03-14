#!/bin/sh

readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

echo "Checking ${swift_style}Swift${default_style} version:"

if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

eval "$(swiftenv init -)"

readonly swift_required_version=$(cat "${root_path}"/.swift-version)
readonly swift_versions=($(swiftenv versions 2>&1))

if [[ " ${swift_versions[@]} " =~ " ${swift_required_version} " ]]; then
  echo "  Required Swift version ($swift_required_version) already installed."
else
  echo "  Required Swift version ($swift_required_version) not found. Installing..."
  assert_failure '(cd "${root_path}" && swiftenv install $swift_required_version)'
  assert_warning '(cd "${root_path}" && swiftenv rehash)'
fi

echo ""
