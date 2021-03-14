#!/bin/sh

readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

echo "Checking ${ruby_style}Ruby${default_style} version:"

if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

eval "$(rbenv init -)"

readonly ruby_required_version=$(cat "${root_path}"/.ruby-version)
readonly ruby_versions=($(rbenv versions 2>&1))
readonly ruby_install_flags="-Wno-error=implicit-function-declaration"

if [[ " ${ruby_versions[@]} " =~ " ${ruby_required_version} " ]]; then
  echo "  Required Ruby version ($ruby_required_version) already installed."
else
  echo "  Required Ruby version ($ruby_required_version) not found. Installing..."
  assert_failure '(cd "${root_path}" && RUBY_CFLAGS="${ruby_install_flags}" rbenv install $ruby_required_version)'
  assert_warning '(cd "${root_path}" && rbenv rehash)'
fi

echo ""
