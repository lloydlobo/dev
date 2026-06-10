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

# Local AI
#
curl -fsSL https://ollama.com/install.sh | sh                             # ollama   — Ollama (Pull the model: ollama pull qwen2.5:7b; Start Ollama: ollama serve)
# NAME                                 ID              SIZE      MODIFIED      
# llama3.2:1b                          baf6a787fdff    1.3 GB    8 minutes ago    
# qwen2.5:0.5b-base-q4_1               50cc344abeb2    374 MB    21 hours ago     
# qwen2.5:0.5b-base                    24c564a74dea    397 MB    21 hours ago     
# phi:latest                           e2fd6321a5fe    1.6 GB    23 hours ago     
# tinyllama:latest                     2644915ede35    637 MB    23 hours ago     
# llama3.2:3b                          a80c4f17acd5    2.0 GB    47 hours ago     
# nomic-embed-text:latest              0a109f422b47    274 MB    2 days ago       
# all-minilm:l6-v2                     1b226e2802db    45 MB     2 days ago       
# yarn-llama2:latest                   75df67be3cee    3.8 GB    2 days ago       
# llama3.1:8b                          46e0c10c039e    4.9 GB    2 days ago       
# qwen2.5-coder:7b-base-q8_0           a7b028fab948    8.1 GB    2 days ago       
# granite3.1-moe:3b-instruct-q3_K_M    216dcd8f0222    1.6 GB    2 days ago       
# qwen2.5:1.5b-instruct                65ec06548149    986 MB    2 days ago       
# qwen3.5:2b                           324d162be6ca    2.7 GB    4 days ago       
# qwen2.5:7b                           845dbda0ea48    4.7 GB    6 days ago       
# llama3.2:latest                      a80c4f17acd5    2.0 GB    2 weeks ago      

# AI tools                                                                # run:
#
npm install -g opencode-ai                                                # opencode
curl -fsSL https://claude.ai/install.sh | bash                            # claude   — Claude Code
npm install -g @openai/codex                                              # codex    — Codex CLI (OpenAI)
curl -fsSL https://antigravity.google/cli/install.sh | bash               # agy      — AntiGravity CLI
uv tool install --force --python python3.12 --with pip aider-chat@latest  # aider    — Aider
npm install -g --ignore-scripts @earendil-works/pi-coding-agent           # pi       — pi.dev

# AI tooling
npm install -g llm-checker
# npm i -g openclaw@latest # openclaw onboard

# AI plugins
npx skills add vercel-labs/agent-skills
# caveman plugin → ~/.config/opencode/plugins/caveman/ + commands/{caveman,commit,review}.md
#     BROKEN: installer skip caveman-compress.md. Patch = cat > ~/.config/opencode/commands/caveman-compress.md with frontmatter+body.
#     Triggers: "caveman mode" | "be brief" | /caveman. Levels: lite|full|ultra|wenyan*. Off: /caveman off
#     Verify:  node --check ~/.config/opencode/plugins/caveman/plugin.js
#     Remove:  npx -y github:JuliusBrussee/caveman -- --uninstall
#     Caveat:  cavecrew agent schema broken in opencode (tools: vs permission:). No statusline slot.
#
#     curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash # caveman for macOS / Linux / WSL / Git Bash
#     npm i -g @juliusbrussee/caveman-code
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
