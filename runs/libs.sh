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

# DIY ========================================================================
if [[ ! -d "$HOME/Personal/fzf" ]]; then # Installs .fzf.bash .fzf.zsh in $HOME (Useful with ^R `$ (backward-search)`)
  git clone git@github.com:junegunn/fzf.git $HOME/Personal/fzf
  $HOME/Personal/fzf/install
fi
# -----------------------------------------------------------------------------


# IDE =========================================================================

# Zed
# To run Zed from your terminal, you must add ~/.local/bin to your PATH
# Run:
#    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
#    source ~/.zshrc
# To run Zed now, '~/.local/bin/zed'
curl -f https://zed.dev/install.sh | sh

# VSCodium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install codium
# -----------------------------------------------------------------------------
