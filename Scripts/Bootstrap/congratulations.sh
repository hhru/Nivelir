#!/bin/sh

readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

echo ""
echo "${congratulations_style}Congratulations!${default_style} Setting up the development environment successfully completed 🥳"
echo ""
