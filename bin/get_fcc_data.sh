#!/usr/bin/env bash
#
# Copyright © 2017 seamus tuohy, <code@seamustuohy.com>
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the included LICENSE file for details.

# Setup

#Bash should terminate in case a command or chain of command finishes with a non-zero exit status.
#Terminate the script in case an uninitialized variable is accessed.
#See: https://github.com/azet/community_bash_style_guide#style-conventions
set -e
set -u

# DEBUGGING
# set -x

# Read Only variables

readonly PROG_DIR=$(readlink -m $(dirname $0))


curl_w_resume() {
    # From the following one liner
    # export ec=18; while [ $ec -eq 18 ]; do /usr/bin/curl -O -C - "http://..........zip"; export ec=$?; done
    local url="${1}"
    local ec=18;
    while [ $ec -eq 18 ]; do
        curl -O -C - "${url}";
        ec=$?;
    done
}

main() {

    cd "${PROG_DIR}"
    cd ../data
    if [ ! -f "fcc-license-view-data-csv-format.zip" ]; then
        curl_w_resume "http://data.fcc.gov/download/license-view/fcc-license-view-data-csv-format.zip"
    else
        echo "FCC data zip already exists. Skipping...."
    fi
}

readonly START_DIR=$(pwd)

cleanup() {
    cd "${START_DIR}"
    exit 0
}

trap 'cleanup' EXIT

main
