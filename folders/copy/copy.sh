#!/bin/bash

# rsync -avh "src" "dest"

# Load environment variables from .env file
set -a
source .env
set +a

rsync -avh --progress $SRC $DEST