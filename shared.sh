#!/usr/bin/env bash

#=libs
#@shared variables and functions
#@usage:
#@source shared.sh

TAGS_DIR="${HOME}"/.tag
TAGS="${TAGS_DIR}"/tags

error_msg() {
    printf "ERROR:\nSCRIPT:%s\nFUNC:%s\nLINE:%d\n" "$(basename "${0}")" "${FUNCNAME[1]}" "$1"
    exit 1
}
