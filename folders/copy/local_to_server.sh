#!/bin/bash

# Load environment variables from .env file
set -a
source .env
set +a

rsync -avh --progress -e "ssh -i $PEM_KEY_PATH" \
      $LOCAL_PATH \
      $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH

