#!/usr/bin/env bash

#=tag
#@add one or more tags to a file or a directory
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

add() {
    local item=$(realpath "${1}")
    if [[ ! -e "${item}" ]]; then
        error_msg "$LINENO"
    fi
    shift

    local new_tags=()
    for t in "${@}"; do
        new_tags+=($(sed 's/ /_/g' <<< "${t}"))
    done

    # 获取现有标签
    local existing_tags=()
    if grep --quiet "^$item:" "$TAGS"; then
        existing_tags=($(grep "^$item:" "$TAGS" | awk -F':' '{print $2}'))
    fi

    # 合并标签,去重
    local all_tags=()
    local unique_tags=()
    all_tags=("${existing_tags[@]}" "${new_tags[@]}")
    unique_tags=($(echo "${all_tags[@]}" | tr ' ' '\n' | sort -u))

    # grep没有搜索到的话会返回1
    grep -v "^$item:" "$TAGS" >"$TAGS.tmp"
    mv "$TAGS.tmp" "$TAGS"
    echo "$item:${unique_tags[*]}" >>"$TAGS"
}

main() {
    check_parameters "${@}"
    process_opts "${@}"
    shift $((OPTIND - 1))

    add "${@}"
}

main "${@}"
