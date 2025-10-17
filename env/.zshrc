# file: ~/.zshrc - Zsh configuration file
#
# $ DEV_ENV=~/Personal/dev ./dev-env.sh
# $ DEV_ENV=~/Personal/dev ./dev-env.sh --dry
# $ exec zsh # to source ~/.zshrc immediately

# - - - - - - - - - - - - - - - - - - - -
# Profiling Tools
# - - - - - - - - - - - - - - - - - - - -

# Add this to the TOP of your .zshrc:
#   Zsh comes with this super handy profiling tool called zprof.
#   Ref: https://scottspence.com/posts/speeding-up-my-zsh-shell#how-to-profile-your-zsh
#   Ref: https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
#   Ref: https://github.com/zdharma-continuum/zinit-configs/blob/master/brucebentley/zshrc
ENABLE_ZPROF_STARTUP=false

if [[ "$ENABLE_ZPROF_STARTUP" == true ]]; then
    zmodload zsh/zprof 
    PS4=$'%D{%M%S%.} %N:%i> ' # ref: http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    exec 3>&2 2>$HOME/startlog.$$
    setopt xtrace prompt_subst
fi

# - - - - - - - - - - - - - - - - - - - -
# Performance optimizations
# - - - - - - - - - - - - - - - - - - - -

# Aggressive completion caching (rebuild only once per day)
autoload -Uz compinit
if [[ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null) ]]; then
    compinit
else
    compinit -C
fi
# ^ The completion system (compinit) is zsh’s built-in command completion - it’s what shows possible completions when you hit tab.
# | This is a neat trick I found. Instead of rebuilding the completion cache every time, we only do it once a day.
# | Ref: https://gist.github.com/ctechols/ca1035271ad134841284
# ^ For extra robustness (especially on Linux), consider using stat -c instead
# | of stat -f since macOS and GNU stat differ

# Async autosuggestions
typeset -g ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
typeset -g ZSH_AUTOSUGGEST_USE_ASYNC=1

# - - - - - - - - - - - - - - - - - - - -
# Prompt at bottom
# - - - - - - - - - - - - - - - - - - - -

# Put these line in your zshrc, before load instant prompt.
# - Ref: https://github.com/romkatv/powerlevel10k/issues/563#issuecomment-599010321
# - Ref: https://github.com/romkatv/powerlevel10k/issues/563#issuecomment-656503092
printf '\n%.0s' {1..$LINES} # move prompt to the bottom
printf '\033[5 q\r' # change cursor to I-beam

# - - - - - - - - - - - - - - - - - - - -
# Instant Prompt (Powerlevel10k)
# - - - - - - - - - - - - - - - - - - - -

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
#   Initialization code that may require console input (password prompts, [y/n]
#   confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f "/opt/homebrew/bin/brew" ]] &&  eval "$(/opt/homebrew/bin/brew shellenv)" # if you're using macOS, you'll want this enabled

# - - - - - - - - - - - - - - - - - - - -
# Homebrew Configuration
# - - - - - - - - - - - - - - - - - - - -

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
# export PATH="$HOME/bin:/usr/local/bin:$PATH"
# export PATH="/usr/local/sbin:$PATH"  # homebrew requires this

# - - - - - - - - - - - - - - - - - - - -
# Zinit Plugin Manager
# - - - - - - - - - - - - - - - - - - - -

# Auto-install Zinit if not present
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -d $ZINIT_HOME ]] && mkdir -p "$(dirname $ZINIT_HOME)"
[[ ! -d $ZINIT_HOME/.git ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

# Load Zinit completions
autoload -Uz _zinit # if you source zinit.zsh after compinit, add the following snippet after sourcing zinit.zsh
(( ${+_comps} )) && _comps[zinit]=_zinit # NOTE: First time: Reload Zsh to install Zinit: $ exec zsh

# - - - - - - - - - - - - - - - - - - - -
# Plugins and Snippets
# - - - - - - - - - - - - - - - - - - - -

zinit ice depth=1; zinit light romkatv/powerlevel10k # add in Powerlevel10k (theme)

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit light zdharma-continuum/fast-syntax-highlighting  # syntax highlighting (load last to hook into line editor)

zinit snippet OMZL::git.zsh
zinit snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/clipboard.zsh # clipcopy, clippaste
zinit snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/correction.zsh # e.g., alias mv='nocorrect mv'

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::archlinux

(( $+commands[aws] )) && zinit snippet OMZP::aws
(( $+commands[kubectl] )) && zinit snippet OMZP::kubectl
(( $+commands[kubectx] )) && zinit snippet OMZP::kubectx

zinit cdreplay -q # replay cached completions

# - - - - - - - - - - - - - - - - - - - -
# Keybindings
# - - - - - - - - - - - - - - - - - - - -

bindkey -e                            # Emacs mode
bindkey '^p' history-search-backward  # Ctrl+P
bindkey '^n' history-search-forward   # Ctrl+N
bindkey '^[w' kill-region             # Alt+W

# - - - - - - - - - - - - - - - - - - - -
# History Configuration
# - - - - - - - - - - - - - - - - - - - -

HISTSIZE=10000
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory # append rather than overwrite history
setopt hist_find_no_dups  # don't show duplicates in search
setopt hist_ignore_all_dups # delete old duplicates
setopt hist_ignore_dups
setopt hist_ignore_space # ignore commands starting with space
setopt hist_reduce_blanks # remove superfluous blanks
setopt hist_save_no_dups # don't save duplicates
setopt sharehistory # share history across sessions

set -o vi # see also: zvm (vi mode plugin)

# - - - - - - - - - - - - - - - - - - - -
# Completion styling
# - - - - - - - - - - - - - - - - - - - -

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' squeeze-slashes true

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# - - - - - - - - - - - - - - - - - - - -
# Environment Variables
# - - - - - - - - - - - - - - - - - - - -

if [[ -n "$SSH_CONNECTION" ]]; then 
    export EDITOR=$(whence -p vim vi | head -1) # type vs command vs whence
else
    export EDITOR=$(whence -p nvim vim | head -1) # editor (fallback chain for availability) (or use command -v <program>)
fi

# - - - - - - - - - - - - - - - - - - - -
# User configuration 
# - - - - - - - - - - - - - - - - - - - -

# User profile (aliases, functions, exports)
[[ -f $HOME/.zsh_profile ]] && source $HOME/.zsh_profile # NOTE: to make exports available everywhere, move them to .zshenv instead, and remove the source here

# Powerlevel10k configuration: to customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source $HOME/.p10k.zsh 

# - - - - - - - - - - - - - - - - - - - -
# Tool shell integration (NOTE: Few `eval`s are in .zsh_profile)
# - - - - - - - - - - - - - - - - - - - -

# fzf - fuzzy finder
(( $+commands[fzf] )) && eval "$(fzf --zsh)"        

# zoxide - smart directory jumper (uses z)  
#          else use eval "$(zoxide init --cmd cd zsh)"  # (alias to cd)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"  

# - - - - - - - - - - - - - - - - - - - -
# Functions
# - - - - - - - - - - - - - - - - - - - -

# Yazi File Manager - change directory on exit
if (( $+commands[yazi] )); then
    y() { 
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if local cwd="$(command cat -- "$tmp")" && [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
            builtin cd -- "$cwd"
        fi
        command rm -f -- "$tmp"
    }
fi

# TODO: Consider setopt autocd for easier navigation (typing a directory name auto-cds into it).

# - - - - - - - - - - - - - - - - - - - -
# Profiling Output
# - - - - - - - - - - - - - - - - - - - -

# Add this to the BOTTOM of your .zshrc:
if [[ "$ENABLE_ZPROF_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
    zprof > ~/zshprofile$(date +'%s') 
fi # ref: https://github.com/zdharma-continuum/zinit-configs/blob/master/brucebentley/zshrc


# Dotfiles:
#   - https://github.com/dreamsofautonomy/zensh/blob/main/.zshrc
#   - https://github.com/zdharma-continuum/zinit-configs/blob/master/brucebentley/zshrc
#
# See also:
#   - https://medium.com/@Smyekh/tuning-my-terminal-how-zinit-made-my-zsh-setup-fast-flexible-and-actually-fun-5f6450589003
#   - https://miro.medium.com/v2/resize:fit:720/format:webp/1*JiTHiK89CUdF6IP0emwjfg.png
#
# NOTE: If startup time is ever an issue, you can defer heavy plugin loads with
#       zinit’s wait ice:
#
#           zinit ice wait'1'; zinit light zsh-users/zsh-autosuggestions
