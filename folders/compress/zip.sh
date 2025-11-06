#!/bin/bash

set -a
source .env
set +a

zip -9 -r "$DEST" "$SRC"