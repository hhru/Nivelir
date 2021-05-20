#!/bin/sh

readonly arguments=$@
readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

readonly shell_init_line="eval \"\$(/opt/homebrew/bin/brew shellenv)\""

setup_shell() {
  local shell_profile_path=$1

  if [[ ! -f "${shell_profile_path}" ]]; then
    > "${shell_profile_path}"
  fi

  if [[ $(grep -L "${shell_init_line}" "${shell_profile_path}") ]]; then
    echo "${shell_init_line}" >> "${shell_profile_path}"
  fi
}

echo "Checking ${homebrew_style}Homebrew${default_style} installation:"

if which -s brew; then
  if [[ " ${arguments[*]} " == *" ${update_flag} "* ]]; then
    echo "  Homebrew already installed. Updating..."
    assert_failure 'brew update'
  else
    echo "  Homebrew already installed."
  fi
else
  echo "  Homebrew not found. Installing..."
  assert_failure 'bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
fi

if [[ "$(uname -m)" == "arm64" ]]; then
  setup_shell "${HOME}/.zshrc"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ " ${arguments[*]} " == *" ${verify_flag} "* ]]; then
  echo ""
  echo "  Verifying that Homebrew is properly set up..."

  assert_warning 'brew doctor'
fi

echo ""
