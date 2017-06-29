# $FreeBSD: src/share/skel/dot.profile,v 1.19.2.2 2002/07/13 16:29:10 mp Exp $
#
# .profile - Bourne Shell startup script for login shells
#
# see also sh(1), environ(7).
#

# remove /usr/games if you want
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/usr/pkg/sbin:/usr/pkg/bin:$HOME/bin; export PATH

# Setting TERM is normally done through /etc/ttys.  Do only override
# if you're sure that you'll never log in via telnet or xterm or a
# serial line.
# Use cons25l1 for iso-* fonts
# TERM=cons25; 	export TERM

BLOCKSIZE=K;	export BLOCKSIZE
EDITOR=vim;   	export EDITOR
PAGER=less;  	export PAGER

if [[ "$SHELL" == "/usr/local/bin/bash" ]]
then
	if [ -f $HOME/.bashrc ] 
	then
		. $HOME/.bashrc
	fi
else
	# set ENV to a file invoked each time sh is started for interactive use.
	ENV=$HOME/.shrc; export ENV
fi
	
if [ -z $DISPLAY ]
then
	ISX=0
	LANG=C; export LANG
else
	ISX=1
	LANG=en_US.UTF-8;	export LANG
fi
