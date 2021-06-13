#!/bin/sh

readonly arguments=$@
readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

eval "$(rbenv init -)"

export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

if [[ " ${arguments[*]} " == *" ${update_flag} "* ]]; then
  echo "Updating ${ruby_style}Ruby gems${default_style} specified in Gemfile..."
  assert_failure '(cd "${root_path}" && bundle update)'
else
  echo "Installing ${ruby_style}Ruby gems${default_style} specified in Gemfile..."
  assert_failure '(cd "${root_path}" && bundle install)'
fi

echo ""
