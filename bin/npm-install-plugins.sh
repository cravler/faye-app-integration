#!/bin/bash

set -o nounset
set -o errexit

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd)"
DIR="$1"
NPROC=`nproc`

find "${DIR}" -name "node_modules" -print0 |
    xargs -0 --max-procs=${NPROC} rm -Rf

find "${DIR}" -name "package.json" -print0 |
    sed s,/package.json,,g |
    xargs -0 --max-procs=${NPROC} -I % bash -c "${SCRIPT_DIR}/npm-install.sh %"
