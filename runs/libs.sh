#!/usr/bin/env bash

#
# Usage:
#
#   $ DEV_ENV=~/Personal/dev ./run.sh libs --dry
#   $ DEV_ENV=~/Personal/dev ./run.sh libs
#

sudo apt -y update

#/////////////////////////////////////////////////
# ESSENTIALS
#/////////////////////////////////////////////////
sudo apt -y install build-essential libtool-bin python3-dev automake flex bison libglib2.0-dev
sudo apt -y install git ripgrep pavucontrol xclip jq shutter python3-pip python3-venv
sudo apt -y install moreutils

#=================================================
# Compilers
#=================================================
sudo apt -y install nasm

sudo apt -y install clang
if false; then # install gcc-13
	# WARNING: installing gcc-13 via apt doesn't replace the default /usr/bin/gcc, it installs as /usr/bin/gcc-13.
	sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
	cat /etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-*.list
	apt-cache search gcc | grep '^gcc-[0-9]' | tail
	sudo apt -y install gcc-13 g++-13
	# Use update-alternatives to configure default gcc and g++:
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 110
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 130
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 110
	sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 130
	# Then run:
	sudo update-alternatives --config gcc
	sudo update-alternatives --config g++
	# Finally, select GCC 13 from the menu.
	# ...
	# Verify
	which gcc
	gcc --version
fi

#=================================================
# Package Managers
#=================================================

# === homebrew ===

# homebrew prerequisites: build-essential gcc
#
# It's self contained in /home/linuxbrew/.linuxbrew and can easily be blown away - doesn't interfere with the system (see https://www.ypsidanger.com/homebrew-is-great-on-linux/)
# ==> Caveats
# zsh completions have been installed to:
#   /home/linuxbrew/.linuxbrew/share/zsh/site-functions
#
# The default installation of Homebrew puts it in your system path. This can lead to some unfortunate issues, if you brew install ffmpeg this will pull in p11-kit, and adds it to the path. And then Flatpaks stopped working because that library was preferred over the system one. Here's how [we workaround that](https://github.com/ublue-os/config/blob/main/build/ublue-os-just/etc-profile.d/brew.sh?ref=ypsidanger.com) by setting the path only in interactive terminals.
#   #!/usr/bin/env bash
#   [[ -d /home/linuxbrew/.linuxbrew && $- == *i* ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# === uv ===

curl -LsSf https://astral.sh/uv/install.sh | sh
if false; then # first time!?
	echo 'eval "$(uv generate-shell-completion bash)"' >>~/.bashrc
	echo 'eval "$(uv generate-shell-completion zsh)"' >>~/.zshrc
	echo 'eval "$(uvx --generate-shell-completion bash)"' >>~/.bashrc
	echo 'eval "$(uvx --generate-shell-completion zsh)"' >>~/.zshrc
fi
if false; then uv self update; fi

#/////////////////////////////////////////////////
# CONVENIENCE
#/////////////////////////////////////////////////
sudo apt -y install entr lnav plocate redshift rsibreak yt-dlp # redshift -PO 3600
sudo apt -y install direnv timewarrior

sudo apt -y install expect  # https://core.tcl.tk/expect/        Provides: unbuffer
sudo apt -y install sysstat # https://github.com/sysstat/sysstat Provides: iostat

#                             sudo apt -y install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick

# TODO: Ensure --confirm or -y to skip interactive prompts...
brew install eza
brew install git-delta
brew tap philocalyst/tap && brew install caligula
brew install llama.cpp

go install github.com/air-verse/air@latest
go install github.com/charmbracelet/glow@latest
go install github.com/charmbracelet/vhs@latest
go install github.com/cheat/cheat/cmd/cheat@latest

cargo install --jobs=4 bat gping impala navi tealdeer tokei yazi-cli zoxide
cargo install --jobs=4 --locked yazi-fm yazi-cli #  yazi additional dependencies:
cargo install --jobs=4 --locked serpl

# TODO: Ensure --confirm or -y to skip interactive prompts...
uv tool list           # starting... (installs in  /home/user/.local/bin/)
uv tool install httpie # Installed 3 executables: http, httpie, https  #  $ unbuffer http https://example.com | sponge | bat
uv tool install marimo
uv tool install pre-commit
uv tool list # ...finished

#=================================================
# UI/UX
#=================================================
sudo apt -y install feh
sudo apt -y install xcowsay acpitool
sudo apt -y install pinta # pinta - for drawing and image editing

# Compiling ImHex on Linux
# See: https://github.com/WerWolv/ImHex/blob/master/dist/compiling/linux.md

#=================================================
# Media
#=================================================
sudo apt -y install x264 mpv ffmpeg
sudo apt -y install evince


#/////////////////////////////////////////////////
# Dynamic code analysis
#/////////////////////////////////////////////////
sudo apt -y install valgrind afl++

# perf *************************
sudo apt -y install linux-tools-"$(uname -r)"

# Change these kernel variables to allow Perf to collect information without root privileges.
# Keep the settings across system reboots:
# - See [Kernel variables documentation](https://www.kernel.org/doc/Documentation/sysctl/kernel.txt)
# - See [Dynamic code analysis/Profiler](https://www.jetbrains.com/help/clion/cpu-profiler.html#Prerequisites)
sudo sh -c 'echo kernel.perf_event_paranoid=1 >> /etc/sysctl.d/99-perf.conf'
sudo sh -c 'echo kernel.kptr_restrict=0 >> /etc/sysctl.d/99-perf.conf'
sudo sh -c 'sysctl --system'

#/////////////////////////////////////////////////
# DIY
#/////////////////////////////////////////////////
if [[ ! -d "$HOME/Personal/fzf" ]]; then # Installs .fzf.bash .fzf.zsh in $HOME (Useful with ^R `$ (backward-search)`)
	git clone git@github.com:junegunn/fzf.git "$HOME"/Personal/fzf
	"$HOME"/Personal/fzf/install
fi

#/////////////////////////////////////////////////
# IDE
#/////////////////////////////////////////////////

# Zed
#   To run Zed from your terminal, you must add ~/.local/bin to your PATH
#   Run:
#      echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
#      source ~/.zshrc
#   To run Zed now, '~/.local/bin/zed'
#
# curl -f https://zed.dev/install.sh | sh

# VSCodium
#   FOSS version of VSCode
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg |
	gpg --dearmor |
	sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] https://download.vscodium.com/debs vscodium main' |
	sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install codium

#/////////////////////////////////////////////////
# Dotnet extras
#/////////////////////////////////////////////////

dotnet tool install -g fantomas
#   cat << \EOF >> ~/.bash_profile
#   # Add .NET Core SDK tools
#   export PATH="$PATH:/home/user/.dotnet/tools"
#   EOF

# vim: filetype=bash
