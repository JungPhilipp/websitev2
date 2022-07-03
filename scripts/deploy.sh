#!/usr/bin/env bash
set -e
rsync --archive --verbose --recursive --delete --human-readable  public/ pjungphilipp@philipp-jung.de:/web
