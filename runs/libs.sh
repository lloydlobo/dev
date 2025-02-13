#!/usr/bin/env bash

sudo apt -y update

# Essentials ==================================================================

sudo apt -y install git ripgrep pavucontrol xclip jq shutter python3-pip
# -----------------------------------------------------------------------------

# Convenience =================================================================

sudo apt -y install entr lnav plocate
cargo install gping navi tealdeer tokei yazi-cli zoxide

#  yazi additional dependencies:
#
#     `sudo apt -y install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick`
cargo install --locked yazi-fm yazi-cli

go install github.com/air-verse/air@latest
# -----------------------------------------------------------------------------


# DIY =================================================================

# Installs .fzf.bash .fzf.zsh in $HOME (Useful with ^R `$ (backward-search)`)
if [[ ! -d "$HOME/Personal/fzf" ]]; then
  git clone git@github.com:junegunn/fzf.git $HOME/Personal/fzf
  $HOME/Personal/fzf/install
fi
# -----------------------------------------------------------------------------
