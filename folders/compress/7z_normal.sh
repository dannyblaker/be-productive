#!/bin/bash

# normal compression

set -a
source .env
set +a

7z a "$DEST" "$SRC"