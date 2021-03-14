#!/bin/sh

export MINT_PATH="$HOME/.mint"
export MINT_LINK_PATH="$MINT_PATH/bin"

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

run() {
  if [ -z "${root_path}" ]; then
    if [ -z "${helpers_path}" ]; then
      readonly helpers_path="$( cd "$( dirname "$0" )" && pwd )"
    fi

    source "${helpers_path}/script-paths.sh"
  fi

  if which mint >/dev/null; then
    (cd "${root_path}" && mint run "$@")
  else
    echo "error: Mint does not exist"
    exit 1
  fi
}
