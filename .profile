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

if [[ $(basename "$SHELL") == "bash" ]]
then
	if [ -f $HOME/.bashrc ] 
	then
		. $HOME/.bashrc
	fi
else
	# set ENV to a file invoked each time sh is started for interactive use.
	ENV=$HOME/.shrc; export ENV
fi
	
# keeping this in .profile for login shells other than bash
# to use the proper set of environmental variables

## Add a check to verify that this is even relevant
if [ `uname -s` = "DragonFly" ]
then
	if [ -z $DISPLAY ]
	then
		ISX=false; export ISX
		LANG=C; export LANG
		#TERM=cons25; export TERM
	else
		ISX=true; export ISX
		LANG=en_US.UTF-8;	export LANG
		TERM=xterm-256color; export TERM
	fi
else
	if [ `uname -s` = "Linux" ]
	then
		LANG=en_US.UTF-8; export LANG
		TERM=xterm-256color; export TERM
	else
		if [ `uname -s` = "FreeBSD" ]
		then
			if [ -z $DISPLAY ]
			then
				ISX=false; export ISX
				LANG=C; export LANG
				#TERM=cons25; export TERM
			else
				ISX=true; export ISX
				LANG=en_US.UTF-8;	export LANG
				TERM=xterm-256color; export TERM
			fi
		fi
	fi
fi
