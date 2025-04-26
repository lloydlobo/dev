#!/usr/bin/env bash

sudo apt -y update


# Essentials ==================================================================
sudo apt -y install git ripgrep pavucontrol xclip jq shutter python3-pip python3-venv
# -----------------------------------------------------------------------------


# Convenience =================================================================
sudo apt -y install entr lnav plocate redshift rsibreak yt-dlp # redshift -PO 3600
sudo apt -y install expect # https://core.tcl.tk/expect/ provides: unbuffer

cargo install --jobs=4 bat gping navi tealdeer tokei yazi-cli zoxide
cargo install --jobs=4 --locked yazi-fm yazi-cli #  yazi additional dependencies:
#                                          sudo apt -y install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick

go install github.com/air-verse/air@latest
# -----------------------------------------------------------------------------

# DIY =================================================================
if [[ ! -d "$HOME/Personal/fzf" ]]; then # Installs .fzf.bash .fzf.zsh in $HOME (Useful with ^R `$ (backward-search)`)
  git clone git@github.com:junegunn/fzf.git $HOME/Personal/fzf
  $HOME/Personal/fzf/install
fi
# -----------------------------------------------------------------------------
