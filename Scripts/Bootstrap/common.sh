#!/bin/sh

if [ -z "${script_path}" ]; then
  readonly script_path="$( cd "$( dirname "$0" )" && pwd )"
fi

readonly helpers_path="${script_path}/../Helpers"

source "${helpers_path}/script-paths.sh"

readonly default_style='\033[0m'
readonly warning_style='\033[33m'
readonly error_style='\033[31m'

readonly macos_style='\033[38;5;99m'
readonly xcode_style='\033[38;5;75m'
readonly homebrew_style='\033[38;5;208m'
readonly rbenv_style='\033[38;5;43m'
readonly ruby_style='\033[38;5;89m'
readonly bundler_style='\033[38;5;45m'
readonly swiftenv_style='\033[38;5;226m'
readonly swift_style='\033[38;5;208m'
readonly spm_style='\033[38;5;202m'
readonly mint_style='\033[0;38;5;77m'
readonly congratulations_style='\033[38;5;48m'

readonly update_flag='--update'
readonly verify_flag='--verify'

failure() {
  echo "${error_style}Fatal error:${default_style} '$1' failed with exit code $2"
  exit 1
}

warning() {
  echo "${warning_style}Warning:${default_style} '$1' failed with exit code $2"
}

assert_failure() {
  eval $1 2>&1 | sed -e "s/^/    /"

  local exit_code=${PIPESTATUS[0]}

  if [ $exit_code -ne 0 ]; then
    failure "$1" $exit_code
  fi
}

assert_warning() {
  eval $1 2>&1 | sed -e "s/^/    /"

  local exit_code=${PIPESTATUS[0]}

  if [ $exit_code -ne 0 ]; then
    warning "$1" $exit_code
  fi
}

brew_install_if_needed() {
  local options=$@
  local formulae=$1

  if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  if brew ls --versions "${formulae}" &> /dev/null; then
    if [[ " ${options[*]} " == *" ${update_flag} "* ]]; then
      echo "  ${formulae} already installed. Updating..."

      brew_outdated=$(brew outdated 2> /dev/null)
      brew_outdated_exit_code=$?

      if [ $brew_outdated_exit_code -ne 0 ]; then
        echo "    Failed to find outdated formulae."
        warning 'brew outdated' $brew_outdated_exit_code
      else
        if [[ $brew_outdated == *"${formulae}"* ]]; then
          assert_failure 'brew upgrade ${formulae}'
        else
          echo "    Already up-to-date."
        fi
      fi
    else
      echo "  ${formulae} already installed."
    fi
  else
    echo "  ${formulae} not found. Installing..."
    assert_failure 'brew install "${formulae}"'
  fi
}
