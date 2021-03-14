#!/bin/sh

readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

echo "${default_style}"
echo "This script will set up your development environment."
echo "This might take a few minutes. Please don't interrupt the script."
echo ""