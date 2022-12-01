#!/usr/bin/env 

# This file will be load every time you open a new shell. 
# It should only have environment variables you want 
# loaded every time you open a new shell. 
#
# If you want to add any additional customizations (example: oh-my-zsh)
# consider keeping it in your .zshrc file (you can create one).
# 

# Additional information: http://zsh.sourceforge.net/Intro/intro_3.html

export GO111MODULE=on
export GOPATH=~/gopath
export SMSSEND_REPO_PATH=$HOME/projects/messaging-interfaces/sms
export SKIP_DOCKER_RESTART=false
export TOOLS=~/tools/bin
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home
export PYTHON_BIN=$HOME/Library/Python/3.9/bin
export K_BIN=/usr/local/opt/kubernetes-cli@1.22/bin
export PATH=$K_BIN:$PYTHON_BIN:$TOOLS:$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$GOPATH/bin:$PATH

# pyenv 
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# owl
export OWL="/Users/avisnakovs/projects/owl"
eval "$("$OWL/bin/owl" init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

. "$HOME/.cargo/env"
