#!/bin/sh

readonly arguments=$@

readonly update_gems_flag='--update-gems'
readonly update_packages_flag='--update-packages'

readonly project_path="$( pwd )"

readonly required_macos_version='10.14.0'
readonly required_ruby_version=$(cat .ruby-version)
readonly required_swift_version=$(cat .swift-version)

readonly homebrew_url='https://raw.githubusercontent.com/Homebrew/install/master/install'
readonly rbenv_doctor_url='https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor'
readonly rbenv_doctor_temp_path="${project_path}/rbenv_doctor"

readonly rbenv_shell_init_line='if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi'
readonly swiftenv_shell_init_line='if which swiftenv > /dev/null; then eval "$(swiftenv init -)"; fi'

readonly default_style='\033[0m'
readonly warning_style='\033[33m'
readonly error_style='\033[31m'

readonly macos_style='\033[38;5;161m'
readonly xcode_style='\033[38;5;75m'
readonly homebrew_style='\033[38;5;208m'
readonly rbenv_style='\033[38;5;43m'
readonly ruby_style='\033[38;5;89m'
readonly bundler_style='\033[38;5;45m'
readonly cocoapods_style='\033[38;5;161m'
readonly swiftenv_style='\033[38;5;226m'
readonly swift_style='\033[38;5;208m'
readonly spm_style='\033[38;5;202m'
readonly congratulations_style='\033[38;5;48m'

cleanup() {
  rm -rf $rbenv_doctor_temp_path;
}

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

plain_version() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d", $1,$2,$3,$4); }'
}

########################################################################################

welcome_message_step() {
  echo "${default_style}"
  echo "This script will set up your development environment."
  echo "This might take a few minutes. Please don't interrupt the script."
}

macos_version_step() {
  echo ""
  echo "Checking ${macos_style}macOS${default_style} version:"

  macos_version=$(/usr/bin/sw_vers -productVersion  2>&1)

  if [ "$(plain_version $macos_version)" -lt "$(plain_version $required_macos_version)" ]; then
    echo "  ${error_style}Your macOS version ($macos_version) is older then required version ($required_macos_version). Exiting...${default_style}"
    exit 1
  else
    echo "  Your macOS version: $macos_version"
  fi
}

xcode_command_line_tools_step() {
  echo ""
  echo "Checking ${xcode_style}Xcode Command Line Tools${default_style} installation:"

  if xcode-select --version &> /dev/null; then
    echo "  Xcode Command Line Tools already installed."
  else
    echo "  Xcode Command Line Tools not found. Installing..."
    assert_failure 'xcode-select --install'
  fi
}

homebrew_step() {
  echo ""
  echo "Checking ${homebrew_style}Homebrew${default_style} installation:"

  if which -s brew; then
    echo "  Homebrew already installed. Updating..."
    assert_failure 'brew update'
  else
    echo "  Homebrew not found. Installing..."
    assert_failure 'ruby -e "$(curl -fsSL $homebrew_url)" < /dev/null'
  fi

  echo ""
  echo "  Installing 'brew bundle' command..."
  assert_failure 'brew tap Homebrew/bundle'

  echo ""
  echo "  Verifying that Homebrew is properly set up..."
  assert_warning 'brew doctor'
}

brewfile_step() {
  echo ""
  echo "Installing ${homebrew_style}Homebrew formulae${default_style} specified in Brewfile..."
  assert_failure 'brew bundle --no-lock'
}

rbenv_shell_step() {
  shell_profile_path=$1

  if [[ -f $shell_profile_path ]]; then
    shell_profile_content=$(grep rbenv $shell_profile_path 2> /dev/null)

    if [[ $shell_profile_content != *"$rbenv_shell_init_line"* ]]; then
      echo $rbenv_shell_init_line >> $shell_profile_path
    fi
  fi
}

rbenv_step() {
  echo ""
  echo "Checking ${rbenv_style}rbenv${default_style} installation:"

  if brew ls --versions rbenv &> /dev/null; then
    echo "  rbenv already installed."
  else
    echo "  rbenv not found. Installing..."
    assert_failure 'brew install rbenv'
  fi

  assert_warning 'rbenv rehash'

  rbenv_shell_step "${HOME}/.bash_profile"
  rbenv_shell_step "${HOME}/.zshrc"

  eval "$(rbenv init -)"

  echo ""
  echo "  Verifying that rbenv is properly set up..."
  curl -fsSL $rbenv_doctor_url > $rbenv_doctor_temp_path 2> /dev/null
  rbenv_doctor_exit_code=$?

  if [ $rbenv_doctor_exit_code -ne 0 ]; then
    echo "    Failed to load rbenv-doctor script."
    warning 'curl -fsSL $rbenv_doctor_url' $rbenv_doctor_exit_code
  else
    chmod a+x $rbenv_doctor_temp_path
    assert_warning 'bash $rbenv_doctor_temp_path'
  fi
}

ruby_step() {
  echo ""
  echo "Checking ${ruby_style}Ruby${default_style} version:"

  ruby_versions=$(rbenv versions 2>&1)

  if [[ " ${ruby_versions[@]} " =~ " ${required_ruby_version} " ]]; then
    echo "  Required Ruby version ($required_ruby_version) already installed."
  else
    echo "  Required Ruby version ($required_ruby_version) not found. Installing..."
    assert_failure 'rbenv install $required_ruby_version'
    assert_warning 'rbenv rehash'
  fi
}

bundler_step() {
  echo ""
  echo "Checking ${bundler_style}Bundler${default_style} installation:"

  if rbenv which bundler &> /dev/null; then
    echo "  Bundler already installed. Updating..."
    assert_failure 'gem update bundler'
  else
    echo "  Bundler not found. Installing..."
    assert_failure 'gem install bundler'
  fi

  assert_warning 'rbenv rehash'
}

gemfile_step() {
  echo ""

  if [[ " ${arguments[*]} " == *" $update_gems_flag "* ]]; then
    echo "Updating ${ruby_style}Ruby gems${default_style} specified in Gemfile..."
    assert_failure 'bundle update'
  else
    echo "Installing ${ruby_style}Ruby gems${default_style} specified in Gemfile..."
    assert_failure 'bundle install'
  fi
}

swiftenv_shell_step() {
  shell_profile_path=$1

  if [[ -f $shell_profile_path ]]; then
    shell_profile_content=$(grep swiftenv $shell_profile_path 2> /dev/null)

    if [[ $shell_profile_content != *"$swiftenv_shell_init_line"* ]]; then
      echo $swiftenv_shell_init_line >> $shell_profile_path
    fi
  fi
}

swiftenv_step() {
  echo ""
  echo "Checking ${swiftenv_style}swiftenv${default_style} installation:"

  if brew ls --versions swiftenv &> /dev/null; then
    echo "  swiftenv already installed."
  else
    echo "  swiftenv not found. Installing..."
    assert_failure 'brew install kylef/formulae/swiftenv'
  fi

  assert_warning 'swiftenv rehash'

  swiftenv_shell_step "${HOME}/.bash_profile"
  swiftenv_shell_step "${HOME}/.zshrc"

  eval "$(swiftenv init -)"
}

swift_step() {
  echo ""
  echo "Checking ${swift_style}Swift${default_style} version:"

  swift_versions=$(swiftenv versions 2>&1)

  if [[ " ${swift_versions[@]} " =~ " ${required_swift_version} " ]]; then
    echo "  Required Swift version ($required_swift_version) already installed."
  else
    echo "  Required Swift version ($required_swift_version) not found. Installing..."
    assert_failure 'swiftenv install $required_swift_version'
    assert_warning 'swiftenv rehash'
  fi
}

spm_step() {
  echo ""

  if [[ " ${arguments[*]} " == *" $update_packages_flag "* ]]; then
    echo "Updating ${spm_style}Swift packages${default_style} specified in Package.swift..."
    assert_failure 'swift package update'
  else
    echo "Resolving ${spm_style}Swift packages${default_style} specified in Package.swift..."
    assert_failure 'swift package resolve'
  fi
}

congratulations_step() {
  echo ""
  echo ""
  echo "${congratulations_style}Congratulations!${default_style} Setting up the development environment successfully completed 🥳"
  echo ""
}

########################################################################################

trap cleanup EXIT

welcome_message_step
macos_version_step
xcode_command_line_tools_step
homebrew_step
brewfile_step
rbenv_step
ruby_step
bundler_step
gemfile_step
swiftenv_step
swift_step
spm_step
congratulations_step
