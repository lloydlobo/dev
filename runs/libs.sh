#!/usr/bin/env bash

sudo apt -y update

# //////////////////////////////
# ESSENTIALS 
# //////////////////////////////
sudo apt -y install build-essential libtool-bin python3-dev automake flex bison libglib2.0-dev

sudo apt -y install git ripgrep pavucontrol xclip jq shutter python3-pip python3-venv

# //////////////////////////////
# CONVENIENCE 
# //////////////////////////////
sudo apt -y install entr lnav plocate redshift rsibreak yt-dlp # redshift -PO 3600

sudo apt -y install expect                                     # https://core.tcl.tk/expect/        Provides: unbuffer
sudo apt -y install sysstat                                    # https://github.com/sysstat/sysstat Provides: iostat

                                                               # ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick

go install github.com/air-verse/air@latest

cargo install --jobs=4 bat gping navi tealdeer tokei yazi-cli zoxide

cargo install --jobs=4 --locked yazi-fm yazi-cli               #  yazi additional dependencies:

# //////////////////////////////
# Dynamic code analysis
# //////////////////////////////
sudo apt -y install valgrind

# perf *************************
sudo apt -y install linux-tools-$(uname -r)
# Change these kernel variables to allow Perf to collect information without root privileges. 
# Keep the settings across system reboots:
# - See [Kernel variables documentation](https://www.kernel.org/doc/Documentation/sysctl/kernel.txt)
# - See [Dynamic code analysis/Profiler](https://www.jetbrains.com/help/clion/cpu-profiler.html#Prerequisites)
sudo sh -c 'echo kernel.perf_event_paranoid=1 >> /etc/sysctl.d/99-perf.conf'
sudo sh -c 'echo kernel.kptr_restrict=0 >> /etc/sysctl.d/99-perf.conf'
sudo sh -c 'sysctl --system'

# //////////////////////////////
# DIY
# //////////////////////////////
if [[ ! -d "$HOME/Personal/fzf" ]]; then # Installs .fzf.bash .fzf.zsh in $HOME (Useful with ^R `$ (backward-search)`)
  git clone git@github.com:junegunn/fzf.git $HOME/Personal/fzf
  $HOME/Personal/fzf/install
fi


# //////////////////////////////
# IDE
# //////////////////////////////

# Zed
#   To run Zed from your terminal, you must add ~/.local/bin to your PATH
#   Run:
#      echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
#      source ~/.zshrc
#   To run Zed now, '~/.local/bin/zed'

curl -f https://zed.dev/install.sh | sh

# VSCodium
#   FOSS version of VSCode
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install codium
