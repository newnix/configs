#
# ~/.bashrc
#

## Using double hashes for documentation, singles for commenting something out, 4 for pacman use, 3 for entropy use
## This way it's trivial to remove only those hashes that actually need to be removed at any given time.

## If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Let your histfile grow, man
unset HISTFILESIZE
export HISTSIZE=9999 ## Because if I have a single session running that long, I should probaly rotate the file1. Or stop with the frivolous commands.
export HISTTIMEFORMAT='%Y%m%d %R '
# Tell me which shell I'm working in
# echo "Working with $SHELL"
# This broke scp, find another way to announce the shell.

## Set a pty/tty specific histfile
TTY=$(tty)
HISTTTY=$(echo $(tty) | cut -d / -f3,4 | tr '/' '.')
HISTFILE="$HOME/.bash_history.$HISTTTY"

## Set the variables I like/need
export TERM=rxvt-256color
export PATH=$PATH:$HOME/bin:$HOME/bin/c:/sbin:/usr/sbin:/usr/kerberos/sbin:/bin:/usr/local/sbin
export VISUAL=vim
export EDITOR=vim

## Set the time format
export TIMEFORMAT=%P

## Setting the prompt_command
current_date()
{
	echo -n '['$(date +%Y.%m.%d" "%R)'] '
	
}
#PROMPT_COMMAND=current_date

## set some aliases
alias ggrep='grep -niH --color=always'
alias vgrep='grep -niHv --color=always'
alias tv='tail -v'
alias pftp='/enf/bin/pftptools.sh'
alias ls='ls -FG'
alias ssh='ssh -o ServerAliveInterval=30'
alias zggrep='zgrep -niH --color=always'
alias zless='zless -NJ'

## Use the ipmi view tool
alias ipmi='~/ipmi/IPMIView_V2.11.0_bundleJRE_Linux_x64_20151223/IMPIView20'

## Get the weather!
#TBD

## Launch pidgin and cleanly remove the terminal window.
alias pidgin='pidgin &2>/dev/null & exit'

## shell options
BASH_OPTS="autocd, cdspell, checkhash, checkjobs, checkwinsize, globstar, histappend, histverify, dirspell, progcomp"

## Set up a few nice functions depending on the distro/os
#system()
#{
#	if [[ $(uname -a | awk '{print $2}') == "Sabayon" ]]
#		then 
#			install_cmds=sabayon
#		elif [[ $(uname -a | awk '{print $2}') == "Gentoo" ]]
#			install_cmds=gentoo
#		elif [[ $(uname -a | awk '{print $2}') == "Arch" ]]
#			install_cmds=arch
#		else
#			echo "There's no current command grouping for this OS or Distro."
#	fi
#}


## Allow me to exit by hitting 'q', getting very used to vim
## Changed to 'x' because Gentoo and such
x()
{
	exit
}

## Change the prompt slightly if root, otherwise, use the same prompt. 
## Plan for color change later on, when colors are better understood in prompting.

prompt_tty=$(echo $TTY | cut -d/ -f3,4)

if [ $UID -ne 0 ]
	then

		##set the prompt
		PS1="(dev:$prompt_tty | "'\D{%Y.%m.%d} \A | \[\e[0;31m\]\u\[\e[01;34m\]@\[\e[01;35m\]\h \[\e[01;34m\]| \w  | Jobs: \j | \#)\nHist: \! %\[\e[0;00m\]${NO_COLOUR} '
	else
		##set the prompt (root)
		PS1="(dev:$prompt_tty | "'\D{%Y.%m.%d} \A | \[\e[0;31m\]\u@\h\[\e[01;34m\] | \w  | Jobs: \j | \#)\nHist: \! %\[\e[0;00m\]${NO_COLOUR} '

fi 

## Function to reload the shell, since the whole alias thing doesn't seem to work properly

reload(){
	. $HOME/.bashrc
}

## Get the weather/moon forcast
## Will need some refinement to add in more options, but this should get the basic functionality down
weather(){
	local city="$@"
	if [ z$city == "z" ]
	then 
		city="78217"
	fi

	curl "wttr.in/$city"
}

## Lock the screen. Should also try to set a hotkey binding at some point
lock()
{
	xtrlock -b
}

## Allow me to easily talk to herbstclient like in /etc/xdg/herbstluftwm/autostart
alias hc='herbstclient'

## Sprunger
## Make things easier to upload to sprunge.us
sprunge()
{
    $("$1") | curl -F 'sprunge=<-' http://sprunge.us
}

## Test the term colors
## using a script stolen from tldp.org
if [ -f $HOME/bin/color_test.bash ]
then
	function colors()
	{
		$HOME/bin/color_test.bash
	}
fi



## Prompting colors
## These colors are meant as a quick reference and shorthand for creating colored output
## The color next to them are not necessarily what xresources are translated to, but what the terminal will attempt to display
BLACK='\[\e[0;30\]'
BLUE='\[\e[0;34\]'
GREEN='\[\e[0;32\]'
CYAN='\[\e[0;36\]'
RED='\[\e[0;31\]'


if [ -f $HOME/bin/fetch_dbinfo.bash ]
then
	function dbupdate()
	{
		$HOME/bin/fetch_dbinfo.bash
	}
fi

## This function doesn't seem to work properly for some reason. 
if [ -f $HOME/.dbinfo ]
then
	function db()
	{
		local db_site="$@"
		local db_host
		local db_name
		local db_search_cmd="grep -i $db_site $HOME/.dbinfo"
		local connect ## variable determining how to proceed based of the grep conditional statements

		## Get the database info from the site name
		## asking for clarification with ambiguous results will come later. Maybe.

		if [ $($db_search_cmd | wc -l) -gt 1 ]
		then
			echo "That request was too vague, try again."
			connect=2 ## This status should be able to trigger an interactive menu for the user to select their target
			echo -e -n $'\cc' > $TTY
		elif [ $($db_search_cmd | wc -l) -eq 0 ]
		then
			echo "That site returned no matches."
			connect=1 ## This will cause the function to just exit with an echo message
		else
			db_host=$($db_search_cmd | awk -F ' : ' '{print $6}' | cut -d' ' -f1)
			db_name=$($db_search_cmd | awk -F ' : ' '{print $7}')
			connect=0 ## We have good data, exactly one match, move on to the next conditional
		fi
		## Removed from the if statement to try fixing this function. 

		## Now we connect!
		## Temp modification to issue an echo statement
		echo "Sanity check time, does this command look correct?"
		echo "psql -h $db_host $db_name"
		echo -e "If this is wrong, hit ^C now\n"
		sleep 2
		psql -h $db_host $db_name
		
	}
fi

## Automatically insert my samba authentication file
## Assuming it exists, else informs you to make one to allow for faster access.

## More work is needed to get this corrected, currently hanging on execution. 
#if [ -z $UID ]
#then
#	if [ -f $HOME/.smbauth ]
#	then
#		echo "Using root's samba credentials.."
#	else
#		echo "Root doesn't have any saved samba credentials."
#		echo "Either link them from your home directory or create a new file for root to use."
#	fi
#else
#	if [ -f $HOME/.smbauth ]
#		 then
#			function smbtree()
#			{
#				smbtree -A $HOME/.smbauth "$@"
#			}
#			function smbclient()
#			{
#				smbclient -A $HOME/.smbauth "$@"
#			}
#		 else
#			function smbtree()
#			{
#				echo "You don't have a $HOME/.smbauth file, you'll have to authenticate manually."
#				echo "create a $HOME/.smbauth file with your username and password in it to allow faster access to smb shares."
#				smbtree "$@"
#			}
#			function smbclient()
#			{
#				echo "You don't have a $HOME/.smbauth file, you'll have to authenticate manually."
#				echo "create a $HOME/.smbauth file with your username and password in it to allow faster access to smb shares."
#				smbclient "$@"
#			}
#	fi			
#fi

## remove multimedia files
## The way this function was written actually allows it to 
## remove all files with a matching extension, not just audio.
function rmext()
{
	local format=${1}
	
	case $format in
	# set up a couple of flags
	# three help options to match multiple conventions
	-?		) echo -e "Usage rmext \$MEDIA_FORMAT (eg. mp3)\nSee Also: man rm";;
	-h		) echo -e "Usage rmext \$MEDIA_FORMAT (eg. mp3)\nSee Also: man rm";;
	--help	) echo -e "Usage rmext \$MEDIA_FORMAT (eg. mp3)\nSee Also: man rm";;
	wav		) rm *.wav;;
	mp3		) rm *.mp3;;
	flac	) rm *.flac;;
	spx		) rm *.spx;;
	ogg		) rm *.ogg;;
	aac		) rm *.aac;;
	# something not listed
	*		) rm *.$1;;
	esac
}

## Show me the sites managed
function sites()
{
	## This only works on othosts, but will be nice to have available with the new history format being used.
	enfver | grep otser | cut -d_ -f2 | awk '{print $1}' | sort -d
}

## Show me all files matching an extension
function lsext()
{
	local ext=${1}

	case $extension in
	## some boilerplate options
	## three common help invocations to explain what's happening.
	-?		) echo -e "Usage: lsext \$EXTENSION (eg. csv)";;
	-h		) echo -e "Usage: lsext \$EXTENSION (eg. csv)";;
	--help	) echo -e "Usage: lsext \$EXTENSION (eg. csv)";;
	txt		) ls -halt *.txt;;
	csv		) ls -halt *.csv;;
	bash	) ls -halt *.bash;;
	mp3		) ls -halt *.mp3;;
	## I'm not your mother. 
	## I'm not planning out everything.
	*		) ls -halt *.$1;;
	esac
}

if [ -x /usr/bin/fortune ]
then
	fortune -a
elif [ -x /usr/games/fortune ]
then
	fortune -a 
fi
