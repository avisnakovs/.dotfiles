# ─────────────────────────────────────────────
# Zsh Configuration
# Replaces oh-my-zsh with zinit (10x faster startup)
# ─────────────────────────────────────────────

# ── Zinit (plugin manager) ──
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# ── Oh-my-zsh plugins you actually use (loaded fast via zinit) ──
zinit snippet OMZL::history.zsh           # Command history
zinit snippet OMZL::key-bindings.zsh      # Standard key bindings
zinit snippet OMZL::completion.zsh        # Tab completion
zinit snippet OMZL::directories.zsh       # Directory shortcuts (..  ...)
zinit snippet OMZP::git                   # Git aliases (gst, gco, gp, etc.)
zinit snippet OMZP::docker                # Docker completions
zinit snippet OMZP::kubectl               # Kubectl completions

# ── Fast plugins ──
zinit light zsh-users/zsh-autosuggestions      # Fish-like suggestions
zinit light zsh-users/zsh-syntax-highlighting  # Command highlighting
zinit light zsh-users/zsh-completions          # Additional completions

# ── Homebrew ──
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── Go ──
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# ── Java (Quarkus) ──
export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

# ── Ruby (Homebrew, replaces system Ruby 2.6) ──
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# ── .NET (Unity C#) ──
export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
export PATH="$DOTNET_ROOT:$PATH"

# ── Node (if installed via brew) ──
export PATH="/opt/homebrew/opt/node/bin:$PATH"

# ── Editor ──
export EDITOR="nvim"
export VISUAL="nvim"

# ── History ──
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY          # Share between terminals
setopt HIST_IGNORE_ALL_DUPS   # No duplicates
setopt HIST_REDUCE_BLANKS     # Remove extra whitespace

# ── Aliases ──
alias v="nvim"
alias vim="nvim"
alias lg="lazygit"
alias cat="bat"
alias ls="eza --icons"
alias la="eza --long --all --group --icons"
alias ll="eza -la --icons --git"
alias lt="eza --tree --level=2 --icons"
alias gs="git status"
alias gd="git diff"
alias gc="git commit"
alias gp="git push"

# Kubernetes & Docker
alias k="kubectl"
alias dk="docker"

# Python
alias python="python3"

# Claude Code
alias cc="claude"

# ── Functions ──

# Interactive process killer using fzf
# Usage: kp [signal] — defaults to kill -9
function kp() {
  local pid=$(ps -ef | sed 1d | eval "fzf -m --header='[kill:process]'" | awk '{print $2}')
  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

# Pretty git log with graph, colors, relative dates
# Usage: gl [git log args]
function gl() {
  git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset" --abbrev-commit --date=relative $@
}

# Set git user identity for current repo
function ginit() {
  git config user.name "avisnakovs"
  git config user.email aleksandrs@hey.com
}

# mkdir and cd into it
function mkdirc() {
  mkdir -p "$1" && cd "$1"
}

# ── fzf ──
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

# ── Zoxide (smart cd) ──
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# ── Starship prompt (fast, pretty, informative) ──
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi
