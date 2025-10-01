#!/bin/bash

set -a
source .env
set +a

grep -sIr --exclude-dir={dev,proc,run,sys} "$SEARCH_TERM" $STARTING_DIRECTORY >> $OUTPUT_FILE