#!/usr/bin/env bash
set -ex

if [ -z ${INCLUDE_DATA+x} ]; then
    rsync --archive --verbose --recursive --delete --human-readable --exclude='*.pdf' --exclude='*.pptx' public/ pjungphilipp@philipp-jung.de:/web
else
    rsync --archive --verbose --recursive --delete --human-readable                                      public/ pjungphilipp@philipp-jung.de:/web
fi

