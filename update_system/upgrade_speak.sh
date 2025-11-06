#!/bin/bash

espeak "Updating packages"
sudo apt-get -y update

espeak "Upgrading packages"
sudo apt-get -y upgrade

espeak "Updating snap store"
sudo killall snap-store
sudo snap refresh
sudo systemctl daemon-reload
sudo systemctl restart snapd.service

espeak "enabling unprivileged user namespaces for docker"
sudo sysctl -w kernel.apparmor_restrict_unprivileged_unconfined=0
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0

espeak "Check for Rootkits"
sudo rkhunter --propupd
sudo rkhunter --check --sk

espeak "done"

