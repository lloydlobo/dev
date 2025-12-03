#!/usr/bin/env bash
# USAGE:
#
#   $ DEV_ENV=~/Personal/dev ./run.sh libs --dry
#   $ DEV_ENV=~/Personal/dev ./run.sh libs
#
set -euo pipefail

sudo apt -y update

#-------------------------------------------------
# ESSENTIALS
#-------------------------------------------------
sudo apt -y install build-essential libtool-bin python3-dev automake flex bison libglib2.0-dev
sudo apt -y install git ripgrep pavucontrol xclip jq shutter python3-pip python3-venv
sudo apt -y install moreutils

#-------------------------------------------------
# COMPILERS
#-------------------------------------------------
sudo apt -y install nasm
sudo apt -y install clang

#-------------------------------------------------
# PACKAGE MANAGERS
#-------------------------------------------------
# --- homebrew ---
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # homebrew prerequisites: build-essential gcc

# --- uv ---
curl -LsSf https://astral.sh/uv/install.sh | sh
if false; then uv self update; fi

#-------------------------------------------------
# CONVENIENCE
#-------------------------------------------------
sudo apt -y install entr lnav plocate redshift rsibreak yt-dlp # redshift -PO 3600
sudo apt -y install direnv timewarrior

sudo apt -y install expect  # https://core.tcl.tk/expect/        Provides: unbuffer
sudo apt -y install sysstat # https://github.com/sysstat/sysstat Provides: iostat

# -- sudo apt -y install 7zip poppler-utils fd-find imagemagick --

brew install asciinema
brew tap philocalyst/tap && brew install caligula
brew install cbonsai croc eza git-delta grex llama.cpp ncdu syncthing w3m
brew install opencode # ai stuff
brew install texlive # LaTeX
brew install pandoc # univeral markup converter
brew install hunspell # spellcheck
brew install pngquant # like TinyPNG

cargo install --jobs=4 bat gping impala navi tealdeer tokei yazi-cli zoxide
cargo install --jobs=4 --locked yazi-fm yazi-cli #  yazi additional dependencies:
cargo install --jobs=4 --locked serpl

go install github.com/air-verse/air@latest
go install github.com/charmbracelet/glow@latest
go install github.com/charmbracelet/vhs@latest
go install github.com/cheat/cheat/cmd/cheat@latest

uv tool install htpie  # Installed 3 executables: http, httpie, https  #  $ unbuffer http https://example.com | sponge | bat
uv tool install marimo
uv tool install organize-tool
#     $ crontab -e
#         Add: 0 */6 * * * cd ~ && organize run
uv tool install pre-commit

#-------------------------------------------------
# UI/UX
#-------------------------------------------------
sudo apt -y install feh xcowsay acpitool pinta  # pinta - for drawing and image editing

#-------------------------------------------------
# Media
#-------------------------------------------------
sudo apt -y install x264 mpv ffmpeg
sudo apt -y install evince

#-------------------------------------------------
# Dynamic code analysis
#-------------------------------------------------
sudo apt -y install valgrind afl++

# --- perf ---
sudo apt -y install linux-tools-"$(uname -r)"

# Change these kernel variables to allow Perf to collect information
# without root privileges.
# Keep the settings across system reboots:
#   - See [Kernel variables documentation](https://www.kernel.org/doc/Documentation/sysctl/kernel.txt)
#   - See [Dynamic code analysis/Profiler](https://www.jetbrains.com/help/clion/cpu-profiler.html#Prerequisites)
sudo sh -c 'echo kernel.perf_event_paranoid=1 >> /etc/sysctl.d/99-perf.conf'
sudo sh -c 'echo kernel.kptr_restrict=0 >> /etc/sysctl.d/99-perf.conf'
sudo sh -c 'sysctl --system'

#-------------------------------------------------
# DIY
#-------------------------------------------------
if [[ ! -d "$HOME/Personal/fzf" ]]; then 
    # Installs .fzf.bash .fzf.zsh in $HOME (Useful with ^R `$ (backward-search)`)
    git clone git@github.com:junegunn/fzf.git "$HOME"/Personal/fzf
    "$HOME"/Personal/fzf/install
fi

#-------------------------------------------------
# IDE
#-------------------------------------------------
# --- Zed ---
#     curl -f https://zed.dev/install.sh | sh
#     ^
#     | Zed: To run Zed from your terminal, you must add ~/.local/bin to your PATH
#     |   Run:
#     |      echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
#     |      source ~/.zshrc
#
# --- VSCodium ---
#     FOSS version of VSCode
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg |
    gpg --dearmor |
    sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] https://download.vscodium.com/debs vscodium main' |
    sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install codium

#-------------------------------------------------
# DOTNET EXTRAS
#-------------------------------------------------
dotnet tool install -g fantomas
# ^
# |  cat << \EOF >> ~/.bash_profile
# |  # Add .NET Core SDK tools
# |  export PATH="$PATH:/home/user/.dotnet/tools"
# |  EOF

# vim: filetype=zsh
