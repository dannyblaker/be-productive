#!/bin/bash

# Ridiculously high compression. Warning: may take a long time. 
# If the files you are compressing are large, you will need a lot of RAM 
# to compress successfully.

set -a
source .env
set +a

7z a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0 $DEST $SRC
