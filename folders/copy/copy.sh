#!/bin/bash

# Load environment variables from .env file
set -a
source .env
set +a

rsync -avh --progress $SRC $DEST