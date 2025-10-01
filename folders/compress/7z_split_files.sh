#!/bin/bash

set -a
source .env
set +a

# split files into multiple 7z archives of 600mb each with no compression

7z a -t7z -m0=Copy -v600M -mx0 "$DEST" "$SRC"