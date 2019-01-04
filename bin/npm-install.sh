#!/bin/bash

set -o errexit
set -o nounset

function handleError() {
    local LINE="$1"
    local MESSAGE="${2:-}"
    echo "Error on or near line ${LINE}${2:+: }${MESSAGE:-}."
    exit 255
}

trap 'handleError ${LINENO}' ERR

if [ "$#" -ne "1" ]; then
    handleError "Usage: $0 <directory>"
fi

PACKAGE_DIR=$1
CACHE_DIR="tmp"

cd "${PACKAGE_DIR}"
rm -Rf "${PACKAGE_DIR}/node_modules"
npm install --cache="${CACHE_DIR}" --loglevel=error
#npm cache clean --force --cache="${CACHE_DIR}"
rm -Rf "${CACHE_DIR}"
