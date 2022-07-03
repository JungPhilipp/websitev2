#!/usr/bin/env bash
DEPLOY_USERNAME_="${DEPLOY_USERNAME:-pjungphilipp}"
rsync --archive --verbose --recursive --delete --human-readable  public/ ${DEPLOY_USERNAME_}@philipp-jung.de:/web
