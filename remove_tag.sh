#!/usr/bin/env bash

#=tag
#@remove one or more tags from a file or a directory
#@usage:
#@script.sh file/directory tag[s]

SELF_ABS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${SELF_ABS_DIR}"/shared.sh

usage() {
    local script
    script=$(basename "$0")
    echo "usage:"
    echo "$script file/directory tag[s]"
    exit 1
}

check_parameters() {
    if (("$#" < 2)); then
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

remove() {
    local item=$(realpath "${1}")
    if [[ ! -e "${item}" ]]; then
        error_msg "$LINENO"
    fi
    shift

    declare -A remove_tags_map
    for e in "${@}"; do
        remove_tags_map["$e"]="value"
    done

    local final_tags=()

    if grep --quiet "^$item:" "$TAGS"; then
        local existing_tags
        existing_tags=($(grep "^$item:" "$TAGS" | awk -F':' '{print $2}'))

        for e in "${existing_tags[@]}"; do
            if [[ ! -v remove_tags_map[$e] ]]; then
                final_tags+=("$e")
            fi
        done

        grep -v "^$item:" "$TAGS" >"$TAGS.tmp"
        mv "$TAGS.tmp" "$TAGS"
        if [[ ${#final_tags[@]} -gt 0 ]]; then
            echo "$item:${final_tags[*]}" >>"$TAGS"
        fi
    fi
}

main() {
    check_parameters "${@}"
    process_opts "${@}"
    shift $((OPTIND - 1))

    remove "${@}"
}

main "${@}"
