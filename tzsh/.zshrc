# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/avisnakovs/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  fzf
  zsh-completions
  zsh-syntax-highlighting
  zsh-autosuggestions
  )

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# colorls
if [ -x "$(command -v colorls)" ]; then
    alias ls="colorls"
    alias la="colorls -al"
fi

# exa
if [ -x "$(command -v exa)" ]; then
    alias ls="exa"
    alias la="exa --long --all --group"
fi

# neovim
if [ -x "$(command -v nvim)" ]; then
    alias vim="nvim"
fi

autoload -U compinit && compinit#!/bin/bash

function mkdirc() {
  mkdir $1
  cd $1
}

function dtk() {
  eval $(minikube docker-env)
}

function k() {
  kubectl "$@"
}

function dk() {
  docker "$@"
}

function dirm() {
  docker rmi $(docker images -a -q)
}

function dcstop() {
  docker stop $(docker ps -aq)
}

function dcrm() {
  docker rm $(docker ps -aq)
}

function miniprune() {
  minikube stop; minikube delete &&
  docker stop $(docker ps -aq) &&
  rm -rf ~/.kube ~/.minikube &&
  sudo rm -rf /usr/local/bin/localkube /usr/local/bin/minikube &&
  launchctl stop '*kubelet*.mount' &&
  launchctl stop localkube.service &&
  launchctl disable localkube.service &&
  sudo rm -rf /etc/kubernetes/ &&
  docker system prune -af --volumes
}

function kp() {
  local pid=$(ps -ef | sed 1d | eval "fzf -m --header='[kill:process]'" | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

function gl() {
    git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset" --abbrev-commit --date=relative $@
}

function fextractor() {
    kubectl port-forward $(kubectl get pods | grep 'html-extractor' | awk '{print $1;}') 8086:8080
}

function fredis() {
    kubectl port-forward -n service $(kubectl get pods -n service | grep redis | awk '{print $1;}') 6379:6379
}

function fdetector() {
    kubectl port-forward $(kubectl get pods | grep 'nudenet-detector' | awk '{print $1;}') 8084:8080
}

function fclassifier() {
    kubectl port-forward $(kubectl get pods | grep 'nudenet-classifier' | awk '{print $1;}') 8085:8080
}

function klogs() {
    k logs $(kubectl get pods | grep $@ | awk '{print $1;}') | bat
}

function klogsf() {
    k logs -f $(kubectl get pods | grep $@ | awk '{print $1;}')
}

function ginit() {
    git config user.name "avisnakovs"
    git config user.email alexander@visnakovs.com
}

function dtoken() {
  curl -s --header "Content-Type: application/json" \
  --request POST \
  --data '{"email":"tech@bidstack.com","password":"password"}' \
  https://dev.api.pgde.cc/api/v1/auth/login \
| python3 -c "import sys, json, subprocess; token = json.load(sys.stdin)['token']['token']; subprocess.run('pbcopy', universal_newlines=True, input=token); print(token)"
}

function stoken() {
  curl -s --header "Content-Type: application/json" \
  --request POST \
  --data '{"email":"tech@bidstack.com","password":"password"}' \
  https://stage.api.pgde.cc/api/v1/auth/login \
| python3 -c "import sys, json, subprocess; token = json.load(sys.stdin)['token']['token']; subprocess.run('pbcopy', universal_newlines=True, input=token); print(token)"
}

function ltoken() {
  curl -s --header "Content-Type: application/json" \
  --request POST \
  --data '{"email":"tech@bidstack.com","password":"password"}' \
  http://localhost:8881/api/v1/auth/login \
| python3 -c "import sys, json, subprocess; token = json.load(sys.stdin)['token']['token']; subprocess.run('pbcopy', universal_newlines=True, input=token); print(token)"
}

function uscript() {
    echo "cd /Applications/Unity/Hub/Editor/"
    echo "cd /Unity.app/Contents/Resources/ScriptTemplates"
}

