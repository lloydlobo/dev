# - - - - - - - - - - - - - - - - - - - -
# Profiling Tools
# - - - - - - - - - - - - - - - - - - - -

ENABLE_ZPROF_STARTUP=false

# Zsh comes with this super handy profiling tool called zprof.
#   Ref: https://scottspence.com/posts/speeding-up-my-zsh-shell#how-to-profile-your-zsh
#   Ref: https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
#   Ref: https://github.com/zdharma-continuum/zinit-configs/blob/master/brucebentley/zshrc
if [[ "$ENABLE_ZPROF_STARTUP" == true ]]; then
    zmodload zsh/zprof # add this to the TOP of your .zshrc
    PS4=$'%D{%M%S%.} %N:%i> ' # ref: http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    exec 3>&2 2>$HOME/startlog.$$
    setopt xtrace prompt_subst
fi

# Performance optimizations
#   (The auto-updates are nice, but I’d rather do them manually when I want to)
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPIX="true"

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# - - - - - - - - - - - - - - - - - - - -
# Instant Prompt
# - - - - - - - - - - - - - - - - - - - -

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Dotfiles:
# - https://github.com/dreamsofautonomy/zensh/blob/main/.zshrc
if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# - - - - - - - - - - - - - - - - - - - -
# Homebrew Configuration
# - - - - - - - - - - - - - - - - - - - -

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
# export PATH="$HOME/bin:/usr/local/bin:$PATH"

# # Homebrew Requires This.
# export PATH="/usr/local/sbin:$PATH"

# - - - - - - - - - - - - - - - - - - - -
# Zsh Core Configuration
# - - - - - - - - - - - - - - - - - - - -

# === Cache completions aggressively ===
# # Load The Prompt System And Completion System And Initilize Them.
# autoload -Uz compinit promptinit
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi
# ^ The completion system (compinit) is zsh’s built-in command completion - it’s what shows possible completions when you hit tab. 
# | This is a neat trick I found. Instead of rebuilding the completion cache every time, we only do it once a day.
# | Ref: https://gist.github.com/ctechols/ca1035271ad134841284


# - - - - - - - - - - - - - - - - - - - -
# Zinit Configuration
# - - - - - - - - - - - - - - - - - - - -
# See also:
#   - https://medium.com/@Smyekh/tuning-my-terminal-how-zinit-made-my-zsh-setup-fast-flexible-and-actually-fun-5f6450589003
#   - https://miro.medium.com/v2/resize:fit:720/format:webp/1*JiTHiK89CUdF6IP0emwjfg.png

# Download Zinit, if it's not there yet
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit # if you source zinit.zsh after compinit, add the following snippet after sourcing zinit.zsh
(( ${+_comps} )) && _comps[zinit]=_zinit

# First time: Reload Zsh to install Zinit: $ exec zsh

# - - - - - - - - - - - - - - - - - - - -
# Plugins and snippets
# - - - - - - - - - - - - - - - - - - - -

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

if false; then # NOTE: disabled here as we load completions earlier
    autoload -Uz compinit && compinit # load completions
fi

zinit cdreplay -q

# - - - - - - - - - - - - - - - - - - - -
# Theme / Prompt Customization
# - - - - - - - - - - - - - - - - - - - -

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#   [WARNING]: Console output during zsh initialization detected.
#   When using Powerlevel10k with instant prompt, console output during zsh initialization may indicate issues.
#   Recommended: Change ~/.zshrc so that it does not perform console I/O after the instant prompt preamble. See the link below for details.


# - - - - - - - - - - - - - - - - - - - -
# Keybindings
# - - - - - - - - - - - - - - - - - - - -

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region


# - - - - - - - - - - - - - - - - - - - -
# History
# - - - - - - - - - - - - - - - - - - - -

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# - - - - - - - - - - - - - - - - - - - -
# Completion styling
# - - - - - - - - - - - - - - - - - - - -

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# - - - - - - - - - - - - - - - - - - - -
# Library 
# - - - - - - - - - - - - - - - - - - - -

# zi snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/clipboard.zsh
# zi snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/termsupport.zsh


# - - - - - - - - - - - - - - - - - - - -
# User configuration 
# - - - - - - - - - - - - - - - - - - - -

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

source ~/.zsh_profile

# - - - - - - - - - - - - - - - - - - - -
# SHELL INTEGRATION
# - - - - - - - - - - - - - - - - - - - -

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)" 

# NOTE: Some other `eval`s are in .zsh_profile
# eval "$(zoxide init zsh)" # to initialize zoxide, add this to your shell configuration file (usually ~/.zshrc)

# =============================================================================
#
# Yazi: Shell wrapper
# We suggest using this y shell wrapper that provides the ability to change the
# current working directory when exiting Yazi.
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# - - - - - - - - - - - - - - - - - - - -
# End Profiling Script
# - - - - - - - - - - - - - - - - - - - -

# See also: https://github.com/zdharma-continuum/zinit-configs
# Real-world configuration files (basically zshrc-s) holding Zinit (former Zplugin) invocations

if [[ "$ENABLE_ZPROF_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
    zprof > ~/zshprofile$(date +'%s') # add this to the BOTTOM of your .zshrc
fi
#
# Ref: https://github.com/zdharma-continuum/zinit-configs/blob/master/brucebentley/zshrc
#
# if [[ "$PROFILE_STARTUP" == true ]]; then
#     unsetopt xtrace
#     exec 2>&3 3>&-
#     zprof > ~/zshprofile$(date +'%s')
# fi
