#!/usr/bin/env bash
# USAGE:
#   $ DEV_ENV=~/Personal/dev ./run.sh libs --dry
#   $ DEV_ENV=~/Personal/dev ./run.sh libs
set -euo pipefail

#-------------------------------------------------
# ESSENTIALS
#-------------------------------------------------
sudo apt -y update
sudo apt -y install \
    build-essential libtool-bin automake flex bison libglib2.0-dev \
    python3-dev python3-pip python3-venv \
    git shellcheck jq moreutils \
    pavucontrol xclip shutter \
    emacs postgresql

#-------------------------------------------------
# COMPILERS
#-------------------------------------------------
sudo apt -y install nasm clang

#-------------------------------------------------
# PACKAGE MANAGERS
#-------------------------------------------------

# Homebrew (prerequisites: build-essential gcc)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh
# uv self update

#-------------------------------------------------
# CONVENIENCE
#-------------------------------------------------
sudo apt -y install \
    direnv timewarrior \
    entr lnav plocate redshift rsibreak timeshift yt-dlp \
    expect sysstat  # expect: unbuffer; sysstat: iostat

brew install \
    asciinema cbonsai croc eza git-delta grex ncdu syncthing w3m \
    texlive pandoc hunspell pngquant

brew tap philocalyst/tap && brew install caligula

# AI tools                                                                # run:
#
npm install -g opencode-ai                                                # opencode
# curl -fsSL https://opencode.ai/install | bash                             # opencode
curl -fsSL https://claude.ai/install.sh | bash                            # claude   — Claude Code
npm install -g @openai/codex                                              # codex    — Codex CLI (OpenAI)
# npm install -g @google/gemini-cli                                         # gemini   — Gemini CLI (free tier: 1K req/day)
curl -fsSL https://antigravity.google/cli/install.sh | bash               # agy      — AntiGravity CLI
uv tool install --force --python python3.12 --with pip aider-chat@latest  # aider    — Aider
curl -fsSL https://ollama.com/install.sh | sh                             # ollama   — Ollama (Pull the model: ollama pull qwen2.5:7b; Start Ollama: ollama serve)
# npm install -g @kilocode/cli                                              # kilo     — Kilo Code
# curl -fsSL https://kilo.ai/cli/install | bash                             # kilo     — Kilo Code

# AI tooling
npm install -g llm-checker
# npm i -g openclaw@latest # openclaw onboard

# AI plugins
#
# caveman plugin → ~/.config/opencode/plugins/caveman/ + commands/{caveman,commit,review}.md
# BROKEN: installer skip caveman-compress.md. Patch = cat > ~/.config/opencode/commands/caveman-compress.md with frontmatter+body.
# Triggers: "caveman mode" | "be brief" | /caveman. Levels: lite|full|ultra|wenyan*. Off: /caveman off
# Verify:  node --check ~/.config/opencode/plugins/caveman/plugin.js
# Remove:  npx -y github:JuliusBrussee/caveman -- --uninstall
# Caveat:  cavecrew agent schema broken in opencode (tools: vs permission:). No statusline slot.
#
# curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash # caveman for macOS / Linux / WSL / Git Bash
# npm i -g @juliusbrussee/caveman-code
mkdir -p ~/.config/opencode/commands
npx -y github:JuliusBrussee/caveman

#-------------------------------------------------
# RUST / CARGO
#-------------------------------------------------
cargo install --jobs=4 bat gping impala navi tealdeer tokei yazi-cli zoxide
cargo install --jobs=4 --locked yazi-fm yazi-cli  # yazi additional dependencies
cargo install --jobs=4 --locked serpl

# ripgrep with PCRE2
sudo apt -y install libpcre2-dev pkg-config
(
    mkdir -p ~/Personal/ripgrep && cd ~/Personal/ripgrep
    cargo clean
    cargo build --release --features 'pcre2'
    cargo install ripgrep
    sudo cp target/release/rg /usr/local/bin/
)
export PATH=/usr/local/bin:$PATH
rg --version

#-------------------------------------------------
# GO
#-------------------------------------------------
go install github.com/air-verse/air@latest
go install github.com/charmbracelet/glow@latest
go install github.com/charmbracelet/vhs@latest
go install github.com/cheat/cheat/cmd/cheat@latest

#-------------------------------------------------
# UV TOOLS
#-------------------------------------------------
uv tool install htpie         # executables: http, httpie, https
uv tool install marimo
uv tool install organize-tool # crontab: 0 */6 * * * cd ~ && organize run
uv tool install rendercv[full]
uv tool install pre-commit

#-------------------------------------------------
# UI/UX & MEDIA
#-------------------------------------------------
sudo apt -y install \
    feh xcowsay acpitool pinta \
    x264 mpv ffmpeg evince

#-------------------------------------------------
# DYNAMIC CODE ANALYSIS
#-------------------------------------------------
sudo apt -y install valgrind afl++ linux-tools-"$(uname -r)"

# Allow perf without root (persistent across reboots)
# See: https://www.kernel.org/doc/Documentation/sysctl/kernel.txt
sudo tee /etc/sysctl.d/99-perf.conf <<'EOF'
kernel.perf_event_paranoid=1
kernel.kptr_restrict=0
EOF
sudo sysctl --system

#-------------------------------------------------
# DIY
#-------------------------------------------------

# fzf — installs .fzf.bash/.fzf.zsh; enables ^R backward-search
if [[ ! -d "$HOME/Personal/fzf" ]]; then
    git clone git@github.com:junegunn/fzf.git "$HOME/Personal/fzf"
    "$HOME/Personal/fzf/install"
fi

#-------------------------------------------------
# DOTNET EXTRAS
#-------------------------------------------------
dotnet tool install -g fantomas
# Add to ~/.bash_profile:
#   export PATH="$PATH:$HOME/.dotnet/tools"

# vim: filetype=zsh
