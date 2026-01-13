#!/usr/bin/env bash
set -euo pipefail

sudo apt -y update

# Antigravity
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
