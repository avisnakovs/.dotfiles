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
export DOOM_PATH=~/.emacs.d/bin
export TOOLS=~/tools/bin
export SMSSEND_REPO_PATH=$HOME/projects/messaging-interfaces/sms
export SKIP_DOCKER_RESTART=true
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home
export PATH=$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$GOPATH/bin:$DOOM_PATH:$PATH

# pyenv 
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# owl
export OWL="/Users/avisnakovs/projects/owl"
eval "$("$OWL/bin/owl" init -)"

