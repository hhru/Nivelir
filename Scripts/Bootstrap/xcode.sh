#!/bin/sh

set -e

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --sudo-password) sudo_password="${2}"; shift ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

if [ -n "${sudo_password}" ]; then
  echo "${sudo_password}" | sudo -S -E "$0" "$@"
  exit $?
fi

readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

echo "Checking ${xcode_style}Xcode${default_style} installation:"

if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

eval "$(rbenv init -)"

readonly xcode_required_version=$(cat "${root_path}"/.xcode-version)
readonly xcode_version=($(bundle exec xcversion selected 2> /dev/null | sed -n 's/Xcode \(.*\)/\1/p'))

if [[ "$xcode_version" == "$xcode_required_version" ]]; then
  echo "  Required Xcode version ($xcode_required_version) already installed."
else
  echo "  Required Xcode version ($xcode_required_version) not found. Installing..."

  bundle exec xcversion update
  bundle exec xcversion install ${xcode_required_version}

  echo "  Selecting Xcode version..."

  bundle exec xcversion select "${xcode_required_version}"
  sudo xcodebuild -license accept
fi

echo ""
