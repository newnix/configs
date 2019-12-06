#
# ~/.bashrc
#

## If not running interactively, don't do anything
[[ $- != *i* ]] && return

## shell options
BASH_OPTS="nullglob autocd cdspell checkhash checkjobs checkwinsize globstar histappend histverify dirspell progcomp cmdhist dotglob nullglob xpg_echo"

for x in ${BASH_OPTS}
do
	shopt -s $x
done

## Let your histfile grow, man
unset HISTFILESIZE
export HISTSIZE=9999 
export HISTTIMEFORMAT='%Y%m%d %R '
export QT_QPA_PLATFORMTHEME=qt5ct
export XDG_RUNTIME_DIR=/tmp/$USER
export SSH_AUTH_SOCK
export SSH_AGENT_PID

## Set the time format
export TIMEFORMAT=%P

## Make functions modular ## 
export BASHPLUGS=$HOME/.bash.d/plugs

## Define the location of the nombre database
export NOMBREDB="${HOME}/.local/nombre.db"

## Set a pty/tty specific histfile
TTY=$(tty)
GPG_TTY=${TTY}
HISTTTY=${TTY/#\/dev\/}
HISTTTY=${HISTTTY//\//.}
HISTFILE="$HOME/.bash_history.$HISTTTY"
if [ ! $DISPLAY ] 
then
	ISX=false
	export LANG="C"
	export TERM=cons25
else
	ISX=true
	export LANG="en_US.UTF-8"
	export TERM="xterm-256color"
fi
# This is recursive (PATH=$PATH:...), and causes undue cluttering of the $PATH as the shell is reloaded for any reason
# Instead, recommend using something like:
#  printf "PATH=%s:%s" $PATH ${ADDITIONS} >> ~/.profile
# which will create a static, expanded entry that can simply be appended as needed
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:$HOME/bin:$HOME/bin/c

## Use neovim if available
if [ -x /usr/local/bin/nvim ]
then
	export VISUAL=nvim
	export EDITOR=nvim
	alias vim='nvim'
elif [ -x /usr/bin/nvim ]
then 
	export VISUAL=nvim
	export EDITOR=nvim
	alias vim='nvim'
elif [ -x /bin/nvim ]
then 
	export VISUAL=nvim
	export EDITOR=nvim
	alias vim='nvim'
else
	export VISUAL=vim
	export EDITOR=vim
fi

## Change the prompt slightly if root, otherwise, use the same prompt. 
## Plan for color change later on, when colors are better understood in prompting.
prompt_tty=${TTY/#\//}
prompt_tty=${prompt_tty/\//:}
if [ $UID -ne 0 ]
	then
		##set the prompt
		PS1="\n($prompt_tty | "'\D{%Y.%m.%d} \A | \[\e[0;31m\]\u\[\e[01;34m\]@\[\e[01;35m\]\H \[\e[01;34m\]| \w | Jobs: \j | \#)\nHist: \! %\[\e[0;00m\]${NO_COLOUR} '
	else
		##set the prompt (root)
		PS1="\n($prompt_tty | "'\D{%Y.%m.%d} \A | \[\e[0;35m\]\u\[\e[01;34m\]@\[\e[01;31m\]\H \[\e[01;34m\]| \w | Jobs: \j | \#)\nHist: \! %\[\e[0;00m\]${NO_COLOUR} '
fi 

## Function to reload the shell, since the whole alias thing doesn't seem to work properly
function loadall() { 
	local plug=""
	for plug in ${BASHPLUGS}/*
	do
		. ${plug}
	done
}

reload(){
	. $HOME/.bashrc
}


## load all the plugins ## 
loadall
