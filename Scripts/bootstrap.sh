#!/bin/sh

set -e

readonly script_path="$( cd "$( dirname "$0" )" && pwd )"
readonly bootstrap_path="${script_path}/Bootstrap"

"${bootstrap_path}/welcome.sh"
"${bootstrap_path}/macos.sh"

"${bootstrap_path}/homebrew.sh" --update --verify
"${bootstrap_path}/rbenv.sh" --update --verify
"${bootstrap_path}/ruby.sh"

"${bootstrap_path}/bundler.sh" --update
"${bootstrap_path}/gemfile.sh"

"${bootstrap_path}/xcode.sh"

"${bootstrap_path}/swiftenv.sh" --update
"${bootstrap_path}/swift.sh" --update

"${bootstrap_path}/spm.sh"

"${bootstrap_path}/mint.sh" --update
"${bootstrap_path}/mintfile.sh"

"${bootstrap_path}/congratulations.sh"
