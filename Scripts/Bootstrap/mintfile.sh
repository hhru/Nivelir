#!/bin/sh

readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"
source "${helpers_path}/script-run.sh"

echo "Installing ${swift_style}Swift tools${default_style} specified in Mintfile..."

if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

assert_failure '(cd "${root_path}" && mint bootstrap)'

echo ""
