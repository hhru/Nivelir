#!/bin/sh

readonly arguments=$@
readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

readonly shell_init_line="if which rbenv > /dev/null; then eval \"\$(rbenv init -)\"; fi"
readonly doctor_url='https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor'
readonly doctor_temp_path="${script_path}/rbenv_doctor"

setup_shell() {
  local shell_profile_path=$1

  if [[ ! -f "${shell_profile_path}" ]]; then
    > "${shell_profile_path}"
  fi

  if [[ $(grep -L "${shell_init_line}" "${shell_profile_path}") ]]; then
    echo "${shell_init_line}" >> "${shell_profile_path}"
  fi
}

cleanup() {
  rm -rf $doctor_temp_path;
}

trap cleanup EXIT

echo "Checking ${rbenv_style}rbenv${default_style} installation:"

brew_install_if_needed rbenv
setup_shell "${HOME}/.zshrc"

if [[ -f "${HOME}/.bash_profile" ]]; then
  setup_shell "${HOME}/.bash_profile"
fi

eval "$(rbenv init -)"

if [[ " ${arguments[*]} " == *" ${verify_flag} "* ]]; then
  echo ""
  echo "  Verifying that rbenv is properly set up..."
  curl -fsSL "${doctor_url}" > "${doctor_temp_path}" 2> /dev/null
  rbenv_doctor_exit_code=$?

  if [ "${rbenv_doctor_exit_code}" -ne 0 ]; then
    echo "    Failed to load rbenv-doctor script."
    warning 'curl -fsSL "${doctor_url}"' "${rbenv_doctor_exit_code}"
  else
    chmod a+x "${doctor_temp_path}"
    assert_warning 'bash "${doctor_temp_path}"'
  fi
fi

echo ""
