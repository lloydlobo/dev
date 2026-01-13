#!/usr/bin/env bash
set -euo pipefail

sudo apt -y update

#-------------------------------------------------
# GOOGLE CHROME
#-------------------------------------------------

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
