#!/bin/bash
#
# Sets remote to your github (or anyone) passed to via the command line
# arg, eg sh remote_set.sh git@github.com:IronistM/local-choice-badge.git

REMOTE_URL="$1"
echo "Setting remote url to: ${REMOTE_URL}"
git remote set-url origin ${REMOTE_URL}
