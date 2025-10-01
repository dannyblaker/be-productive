#!/bin/bash

# very high compression

set -a
source .env
set +a

7z a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=32m -ms=on $DEST $SRC
