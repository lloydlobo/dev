#!/usr/bin/env bash

#
# Usage:
#
#   $ chmod +x ~/Personal/dev/runs/obs.sh # Atleast once
#   $ DEV_ENV=~/Personal/dev ./run.sh obs --dry
#   $ DEV_ENV=~/Personal/dev ./run.sh obs
#

# Also — at this point we've hit a fundamental incompatibility between OBS
# 30.2.3's virtual camera code and v4l2loopback 0.15.x, and we can't downgrade
# v4l2loopback because the kernel is too new for the older version to build.
#
# The cleanest exit from this situation: use the OBS Flatpak, which implements
# virtual camera through pipewire instead of v4l2loopback entirely — bypassing
# this whole issue. You already have pipewire 1.0.3 running. Worth trying
# before we go further down this path.
#
# flatpak install flathub com.obsproject.Studio
# flatpak run com.obsproject.Studio

flatpak install -y flathub com.obsproject.Studio
flatpak install flathub com.obsproject.Studio.Plugin.CompositeBlur
flatpak list | grep CompositeBlur

# vim: filetype=bash
