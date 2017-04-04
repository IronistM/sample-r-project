#!/bin/bash
#
# Sets remote to your github (or anyone) passed to via the command line
# arg, eg sh project_init.sh git@github.com:IronistM/sample-r-project.git

REMOTE_URL="$1"
echo "Init project from template: ${REMOTE_URL}"
