#!/usr/bin/env bash
set -xe

# Device details
readonly DEVICE_NAME = Keychron
readonly VENDOR_ID = 3434
readonly PRODUCT_ID = 0223

# Optional: Identify device
lsusb -v | grep -A 5 -B 5 ${DEVICE_NAME} || true
ls -la /dev/hidraw*

# Create udev rule
readonly RULE_FILE = /etc/udev/rules.d/99-vial.rules
readonly RULE = "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"$VENDOR_ID\", ATTRS{idProduct}==\"$PRODUCT_ID\", MODE=\"0660\", GROUP=\"users\", TAG+=\"uaccess\", TAG+=\"udev-acl\""

echo "$RULE" | sudo tee "$RULE_FILE" > /dev/null

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger



# VIA support on Linux (e.g. Keychron K2 Pro)
#
# 1. Identify device:
#    $ lsusb -v | grep -A5 -B5 Keychron
#    → Look for idVendor=3434, idProduct=0223
#
# 2. Create rule file:
#    $ sudo touch /etc/udev/rules.d/99-vial.rules
#
# 3. Add rule:
#    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0223", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
#
#    (For multiple keyboards, add multiple rules)
#
# 4. Reload udev:
#    $ sudo udevadm control --reload-rules
#    $ sudo udevadm trigger
#
# 5. VIA Web App (https://usevia.app) issues:
#    If you see:
#      - NotAllowedError: Failed to open the device
#      - chrome://device-log/: FILE_ERROR_ACCESS_DENIED
#    ... it's a permission issue on /dev/hidraw*
#
# Fix: Use the udev rule above. Remove it if needed later.
#
# Ref: https://www.reddit.com/r/Keychron/comments/12f3gat/useviaapp_in_linux_ie_via_support_useful_for/
