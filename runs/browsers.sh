#!/usr/bin/env bash
set -euo pipefail

sudo apt -y update

#-------------------------------------------------
# GOOGLE CHROME
#-------------------------------------------------

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

# Chrome update exposed an incomplete/older VAAPI + EGL stack, causing GPU process initialization to fail at startup
# Context: crashed once when profiling a browser game
sudo apt install vainfo libva2 libva-drm2 libva-x11-2 mesa-va-drivers
vainfo # verify
