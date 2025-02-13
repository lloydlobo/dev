#!/usr/bin/env bash

sudo apt -y update

# Essentials
sudo apt -y install git ripgrep pavucontrol xclip jq shutter python3-pip

# Skip this as I am using tealdeer
#   sudo apt -y install tldr

git clone git@github.com:junegunn/fzf.git $HOME/Personal/fzf
$HOME/Personal/fzf/install
#   Do you want to enable fuzzy auto-completion? ([y]/n) y
#   Do you want to enable key bindings? ([y]/n) y
#   Generate /home/user/.fzf.bash ... OK
#   Update fish_user_paths ... Failed
#   Do you want to update your shell configuration files? ([y]/n) y
#   Update /home/user/.bashrc:
#     - [ -f ~/.fzf.bash ] && source ~/.fzf.bash
#       + Added
#   Create /home/user/.config/fish/functions/fish_user_key_bindings.fish:
#       function fish_user_key_bindings
#         fzf --fish | source
#       end
#   Finished. Restart your shell or reload config file.
#      source ~/.bashrc  # bash
#      fzf_key_bindings  # fish
#   Use uninstall script to remove fzf.
#   For more information, see: https://github.com/junegunn/fzf


# Convenience

sudo apt -y install plocate
cargo install gping navi tealdeer tokei yazi-cli zoxide

# Yazi
# sudo apt -y install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick
cargo install --locked yazi-fm yazi-cli
