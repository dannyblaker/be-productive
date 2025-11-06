#!/bin/bash

set -a
source .env
set +a

find $STARTING_DIRECTORY -name $SEARCH_TERM 2>&1 | grep -v "Permission denied"
