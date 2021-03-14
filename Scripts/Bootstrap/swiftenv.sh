#!/bin/sh

readonly arguments=$@
readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

readonly shell_init_line='if which swiftenv > /dev/null; then eval "$(swiftenv init -)"; fi'

setup_shell() {
  local shell_profile_path=$1

  if [[ ! -f "${shell_profile_path}" ]]; then
    > "${shell_profile_path}"
  fi

  if [[ $(grep -L "${shell_init_line}" "${shell_profile_path}") ]]; then
    echo "${shell_init_line}" >> "${shell_profile_path}"
  fi
}

echo "Checking ${swiftenv_style}swiftenv${default_style} installation:"

brew_install_if_needed swiftenv "$arguments"
setup_shell "${HOME}/.zshrc"

if [[ -f "${HOME}/.bash_profile" ]]; then
  setup_shell "${HOME}/.bash_profile"
fi

eval "$(swiftenv init -)"

echo ""
