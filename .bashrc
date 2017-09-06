# status bar
powerline-daemon -q
export POWERLINE_BASH_CONTINUATION=1
export POWERLINE_BASH_SELECT=1

export PATH=$PATH:~/.gem/ruby/2.4.0/bin

if [ -f /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh ]
then
    . /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh
fi
if [ -f /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh ]
then
    . /usr/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
fi

if [ -f /usr/local/bin/nvim ]
then
    export GIT_EDITOR=nvim
fi

# print directories while Making
export MDBG=""

#aliases
alias grepa="grep -Rn --color=auto --exclude=tags"
alias :q="exit"
alias grepc="grep -Rn --color=auto --include=*.c --include=*.h --exclude=tags"

export SHELLCHECK_OPTS="-e SC2086"

# http://blog.macromates.com/2008/working-with-history-in-bash/
export HISTCONTROL=erasedups
export HISTSIZE=10000
export HISTFILESIZE=100000
shopt -s histappend

#git autocompletion
[[ -f /etc/bash_completion ]] && . /etc/bash_completion
# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# funny stuff
fortune | cowsay

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
