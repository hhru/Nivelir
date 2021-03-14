#!/bin/sh

readonly arguments=$@
readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

echo "Checking ${bundler_style}Bundler${default_style} installation:"

if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

eval "$(rbenv init -)"

if rbenv which bundler &> /dev/null; then
  if [[ " ${arguments[*]} " == *" ${update_flag} "* ]]; then
    echo "  Bundler already installed. Updating..."
    assert_failure 'gem update bundler'
  else
    echo "  Bundler already installed."
  fi
else
  echo "  Bundler not found. Installing..."
  assert_failure 'gem install bundler'
fi

echo ""
