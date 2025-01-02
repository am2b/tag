#!/usr/bin/env bash

#=tag
#@init tag:create directory of tag and create database file
#@usage:
#@tag_init.sh

SELF_ABS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${SELF_ABS_DIR}"/shared.sh

usage() {
    local script
    script=$(basename "$0")
    echo "usage:"
    echo "$script"
    exit 1
}

check_parameters() {
    if (("$#" > 1)); then
        usage
    fi
}

process_opts() {
    while getopts ":h" opt; do
        case $opt in
        h)
            usage
            ;;
        *)
            echo "error:unsupported option -$opt"
            usage
            ;;
        esac
    done
}

init() {
    if [[ ! -d "${TAGS_DIR}" ]]; then
        mkdir -p "${TAGS_DIR}"
    fi

    if [[ ! -f "${TAGS}" ]]; then
        touch "${TAGS}"
    fi
}

main() {
    check_parameters "${@}"
    process_opts "${@}"
    shift $((OPTIND - 1))

    init
}

main "${@}"
