#!/usr/bin/env bash
set -euo pipefail
# USAGE:
#
#   $ DEV_ENV=~/Personal/dev ./run.sh ide --dry
#   $ DEV_ENV=~/Personal/dev ./run.sh ide

# --- Prologue ---

# Prevent apt lock issues
sudo systemctl stop packagekit || true

sudo apt -y update

#-------------------------------------------------
# Antigravity
#-------------------------------------------------

# https://antigravity.google/download/linux
# 1. Add the repository to sources.list.d
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
  sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
  sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null

# 2. Update the package cache
sudo apt -y update

# 3. Install the package
sudo apt -y install antigravity

#-------------------------------------------------
# CursorAI
#-------------------------------------------------

# Add Cursor's GPG key
curl -fsSL https://downloads.cursor.com/keys/anysphere.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/cursor.gpg > /dev/null

# Add the Cursor repository
echo "deb [arch=amd64,arm64 signed-by=/etc/apt/keyrings/cursor.gpg] https://downloads.cursor.com/aptrepo stable main" | sudo tee /etc/apt/sources.list.d/cursor.list > /dev/null

# Update and install
sudo apt -y update
sudo apt -y install cursor

#-------------------------------------------------
# VSCode
#-------------------------------------------------

sudo apt -y update
sudo apt -y install software-properties-common apt-transport-https wget
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

sudo apt -y update
sudo apt -y install code

#-------------------------------------------------
# VSCodium
#-------------------------------------------------

#     FOSS version of VSCode
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg |
    gpg --dearmor |
    sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] https://download.vscodium.com/debs vscodium main' |
    sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install codium

#-------------------------------------------------
# Zed
#-------------------------------------------------

curl -f https://zed.dev/install.sh | sh
#     ^
#     | Zed: To run Zed from your terminal, you must add ~/.local/bin to your PATH
#     |   Run:
#     |      echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
#     |      source ~/.zshrc

# --- Epilogue ---

# Restore packagekit
sudo systemctl start packagekit || true
