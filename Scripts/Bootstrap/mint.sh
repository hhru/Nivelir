#!/bin/sh

readonly arguments=$@
readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

readonly shell_mint_path_line="export MINT_PATH=\"\$HOME/.mint\""
readonly shell_mint_link_path_line="export MINT_LINK_PATH=\"\$MINT_PATH/bin\""

setup_shell() {
  local shell_profile_path=$1

  if [[ ! -f "${shell_profile_path}" ]]; then
    > "${shell_profile_path}"
  fi

  if [[ $(grep -L "${shell_mint_path_line}" "${shell_profile_path}") ]]; then
    echo "${shell_mint_path_line}" >> "${shell_profile_path}"
  fi

  if [[ $(grep -L "${shell_mint_link_path_line}" "${shell_profile_path}") ]]; then
    echo "${shell_mint_link_path_line}" >> "${shell_profile_path}"
  fi
}

echo "Checking ${mint_style}Mint${default_style} installation:"

brew_install_if_needed mint "$arguments"
setup_shell "${HOME}/.zshrc"

if [[ -f "${HOME}/.bash_profile" ]]; then
  setup_shell "${HOME}/.bash_profile"
fi

echo ""
