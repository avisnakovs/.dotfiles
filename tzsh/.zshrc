# Path to your oh-my-zsh installation.
export ZSH="/Users/avisnakovs/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

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

eval "$(starship init zsh)"

bindkey -s ^f "tmux-sessionizer\n"

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

_K8SAFETY_DEPDIR=/Users/avisnakovs/Projects/3rdparty; source /Users/avisnakovs/tools/k8s-enable/k8s-safety.sh

