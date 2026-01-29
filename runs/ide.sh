#!/usr/bin/env bash
set -euo pipefail

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
# VSCode
#-------------------------------------------------

sudo apt -y update
sudo apt -y install software-properties-common apt-transport-https wget
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

sudo apt -y update
sudo apt -y install code

# --- Epilogue ---

# Restore packagekit
sudo systemctl start packagekit || true
