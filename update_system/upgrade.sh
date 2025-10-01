#!/bin/bash

sudo apt-get -y update
sudo apt-get -y upgrade
sudo killall snap-store
sudo snap refresh
sudo systemctl daemon-reload
sudo systemctl restart snapd.service
sudo sysctl -w kernel.apparmor_restrict_unprivileged_unconfined=0
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
sudo rkhunter --propupd
sudo rkhunter --check --sk
clamscan --recursive --infected --bell --log=/home/user/Desktop/infected.txt /home/user/Downloads