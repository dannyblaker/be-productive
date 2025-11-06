#!/bin/bash

set -a
source .env
set +a

sudo dpkg -i $DEB_FILE