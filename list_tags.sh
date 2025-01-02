#!/usr/bin/env bash

#=tag
#@list tags of a file or a directory
#@usage:
#@script.sh file/directory

SELF_ABS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${SELF_ABS_DIR}"/shared.sh

usage() {
    local script
    script=$(basename "$0")
    echo "usage:"
    echo "$script file/directory"
    exit 1
}

check_parameters() {
    if (("$#" != 1)); then
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

list() {
    local item=$(realpath "${1}")
    if [[ ! -e "${item}" ]]; then
        error_msg "$LINENO"
    fi
    shift

    local existing_tags=()
    if grep --quiet "^$item:" "$TAGS"; then
        existing_tags=($(grep "^$item:" "$TAGS" | awk -F':' '{print $2}'))
        echo "${existing_tags[@]}"
    fi
}

main() {
    check_parameters "${@}"
    process_opts "${@}"
    shift $((OPTIND - 1))

    list "${1}"
}

main "${@}"
