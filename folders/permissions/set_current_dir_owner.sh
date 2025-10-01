#!/bin/bash

# get the current user
USER=$(whoami)
sudo chown -R $USER:$USER .
chmod -R u+rw .