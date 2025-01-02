#!/usr/bin/env bash

#=tag
#@list files or directories of a tag
#@usage:
#@script.sh tag

SELF_ABS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${SELF_ABS_DIR}"/shared.sh

usage() {
    local script
    script=$(basename "$0")
    echo "usage:"
    echo "$script tag"
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
    local tag="${1}"
    tag=$(sed 's/ /_/g' <<<"${tag}")

    awk -F':' -v tag="$tag" '{
        # 提取冒号后的内容
        content = $2;

        # 将内容按空格分割成数组
        n = split(content, tags, /[[:space:]]+/);

        # 遍历数组,查找是否有匹配的值
        for (i = 1; i <= n; i++) {
            if (tags[i] == tag) {
                print $1;
                break;
            }
        }
    }' "$TAGS"
}

main() {
    check_parameters "${@}"
    process_opts "${@}"
    shift $((OPTIND - 1))

    list "${1}"
}

main "${@}"
