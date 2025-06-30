#!/usr/bin/env bash

#
# Usage:
#
#   $ chmod +x ~/Personal/dev/runs/obs.sh # Atleast once
#   $ DEV_ENV=~/Personal/dev ./run.sh obs --dry
#   $ DEV_ENV=~/Personal/dev ./run.sh obs
#

sudo add-apt-repository -y ppa:obsproject/obs-studio
sudo apt -y install obs-studio

#-------------------------------------------------
# OBS: Virtual camera
#     See: https://obsproject.com/kb/virtual-camera-troubleshooting
#     See: https://github.com/obsproject/obs-studio/wiki/install-instructions#prerequisites-for-all-versions
#-------------------------------------------------
sudo apt -y install v4l2loopback-dkms

# Verify
#     sudo modprobe v4l2loopback
#     ls -1 /sys/devices/virtual/video4linux
# You can find a number of scenarios on the wiki at http://github.com/umlaeute/v4l2loopback/wiki
#
# The specific parameters mentioned are common recommendations from Linux/OBS
# community guides, but the basic sudo modprobe v4l2loopback should be
# sufficient to get it working.
sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1

# You can check what device was created with:
ls /dev/video*

# If you only have /dev/video0, it means the OBS virtual camera didn't create a
# new device. Let's fix this:

# v4l-utils | v4lc-utils | v4l2loopback-utils
sudo apt -y install v4l-utils
sudo apt -y install v4l2loopback-utils
v4l2-ctl --list-devices

#
# Test that OBS virtual camera is working:
#
# - Start OBS
# - Turn on virtual camera
# - Run ffplay (This should show your OBS scene)
#
#    ffplay /dev/video10
#

# NOTE: Unless this is made permanent you gotta do it each time to activate
#       virtual camera!
#
# If the issue is likely that your OBS virtual camera is trying to use
# /dev/video0 which is probably your physical webcam. Let's fix this:
#
# WARN: /dev/video0 sometimes worked for me aswell
#

# Remove the module if loaded
sudo modprobe -r v4l2loopback
# Load it with a specific video number that's not in use
sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1
# You can check what device was created with:
ls /dev/video*
# You should now see both /dev/video0 (your real camera) and /dev/video10 (OBS virtual camera).
v4l2-ctl --list-devices
# This should show OBS output
ffplay /dev/video10

# Make it load automatically at boot
echo 'v4l2loopback' | sudo tee /etc/modules-load.d/v4l2loopback.conf

# Set module options permanently
#     echo 'options v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1' | sudo tee /etc/modprobe.d/v4l2loopback.conf

#-------------------------------------------------
# OBS: GPU driver (NVIDIA)
#-------------------------------------------------
lsmod | grep nouveau
lspci | grep -i nvidia
sudo ubuntu-drivers autoinstall # (NOTE: `sudo reboot` after installation)
ubuntu-drivers devices
nvidia-smi
# If you have issues, you can purge and reinstall:
#     sudo apt purge nvidia-* && sudo ubuntu-drivers autoinstall

echo "=== Setup Complete ==="
echo "1. Reboot if you installed NVIDIA drivers"
echo "2. Start OBS and enable Virtual Camera"
echo "3. Test with: ffplay /dev/video10"
echo "4. Use 'OBS Cam' in video calling apps"

# vim: filetype=bash
