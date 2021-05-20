#!/bin/sh

if [ -z "${helpers_path}" ]; then
  readonly helpers_path="$( cd "$( dirname "$0" )" && pwd )"
fi

readonly tools_path="$( cd "${helpers_path}/../" && pwd )"
readonly root_path="$( cd "${tools_path}/../" && pwd )"
