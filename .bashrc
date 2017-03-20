# status bar
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/local/lib/python2.7/dist-packages//powerline/bindings/bash/powerline.sh

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
. /etc/bash_completion

# funny stuff
fortune | cowsay

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
