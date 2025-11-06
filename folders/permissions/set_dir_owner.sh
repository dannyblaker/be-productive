#!/bin/bash

set -a
source .env
set +a

sudo chown -R $(whoami):$(whoami) "$SRC"
chmod -R u+rw "$SRC"