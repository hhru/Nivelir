#!/bin/sh

readonly helpers_path="$( cd "$( dirname "$0" )" && pwd )/Helpers"
readonly target_name="Nivelir iOS"
readonly derived_data_path="DerivedData"
readonly docs_path="docs"
readonly docarchive_file_path="${derived_data_path}/Build/Products/Debug-iphonesimulator/Nivelir.doccarchive"
readonly url_base_path="Nivelir"

source "${helpers_path}/script-paths.sh"

cd $root_path

xcodebuild docbuild \
  -scheme "${target_name}" \
  -derivedDataPath "${derived_data_path}" \
  -destination 'platform=iOS Simulator,name=iPhone 13'

rm -rf "${docs_path}"

$(xcrun --find docc) process-archive \
  transform-for-static-hosting "${docarchive_file_path}" \
  --output-path "${docs_path}" \
  --hosting-base-path "${url_base_path}"

rm -rf "${derived_data_path}"
