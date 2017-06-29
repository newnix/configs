#
# ~/.bashrc
#

## Using double hashes for documentation, singles for commenting something out, 4 for pacman use, 3 for entropy use
## This way it's trivial to remove only those hashes that actually need to be removed at any given time.

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
export HISTSIZE=9999 ## Because if I have a single session running that long, I should probaly rotate the file1. Or stop with the frivolous commands.
export HISTTIMEFORMAT='%Y%m%d %R '

## Set a pty/tty specific histfile
TTY=$(tty)
HISTTTY=$(echo $TTY | cut -d / -f3,4 | tr '/' '.')
HISTFILE="$HOME/.bash_history.$HISTTTY"
# make sure that we're using the right environment
# depending on whether we're running X or not
# moved to .bashrc from .profile to ensure it's run for each interactive shell
if [ -z $DISPLAY ] # since this should be set every time X starts
then
	ISX=false
else 
	ISX=true
fi
if [ $ISX ] 
then 
	export TERM=cons25
	export LANG=C
else
	export TERM=xterm-256color
	export LANG=en_US.UTF-8
fi
export PATH=$PATH:$HOME/bin:$HOME/bin/c:/sbin:/usr/sbin:/usr/kerberos/sbin:/bin:/usr/local/sbin
export VISUAL=vim
export EDITOR=vim

## Set the time format
export TIMEFORMAT=%P

if [ -x /usr/local/bin/lolcat ]
then
	alias cat='lolcat'
elif [ -x /usr/bin/lolcat ]
then
	alias cat='lolcat'
fi

## Push dotfiles to remote host
if [ -x $HOME/bin/pushconfigs.bash ]
then
	alias pushc=$HOME/bin/pushconfigs.bash
fi

## Change the prompt slightly if root, otherwise, use the same prompt. 
## Plan for color change later on, when colors are better understood in prompting.
prompt_tty=$(echo $TTY | cut -d/ -f3,4)
if [ $UID -ne 0 ]
	then
		##set the prompt
		PS1="\n(dev:$prompt_tty | "'\D{%Y.%m.%d} \A | \[\e[0;31m\]\u\[\e[01;34m\]@\[\e[01;35m\]\h \[\e[01;34m\]| \w  | Jobs: \j | \#)\nHist: \! %\[\e[0;00m\]${NO_COLOUR} '
	else
		##set the prompt (root)
		PS1="\n(dev:$prompt_tty | "'\D{%Y.%m.%d} \A | \[\e[0;35m\]\u\[\e[01;34m\]@\[\e[01;31m\]\h \[\e[01;34m\]| \w  | Jobs: \j | \#)\nHist: \! %\[\e[0;00m\]${NO_COLOUR} '
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
		city="78154"
	fi
	curl "wttr.in/$city"
}

## Sprunger
## Make things easier to upload to sprunge.us
sprunge()
{
    $("$@") | curl -F 'sprunge=<-' http://sprunge.us
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
	if [ -x $(which psql) ]
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
		
		## finally added this condition to prevent trying to connect without a match
		if [ $connect -eq 0 ]
		then
			## Now we connect!
			## Temp modification to issue an echo statement
			echo "Sanity check time, does this command look correct?"
			echo "psql -h $db_host $db_name"
			echo -e "If this is wrong, hit ^C now\n"
			sleep 2
			psql -h $db_host $db_name
		fi
		
	}
	else
		echo "You must have the Postgresql client installed to use this utility."
	fi
fi

## Show me all files matching an extension
function lsext()
{
	local ext=$"@"

	case $ext in
	## some boilerplate options
	## three common help invocations to explain what's happening.
	-?		) echo -e "Usage: lsext \$EXTENSION (eg. csv)";;
	-h		) echo -e "Usage: lsext \$EXTENSION (eg. csv)";;
	--help	) echo -e "Usage: lsext \$EXTENSION (eg. csv)";;
	txt		) ls -halt ./*.txt;;
	csv		) ls -halt ./*.csv;;
	bash	) ls -halt ./*.bash;;
	mp3		) ls -halt ./*.mp3;;
	## I'm not your mother. 
	## I'm not planning out everything.
	*		) ls -halt ./*.${ext};
	esac
}

if [ -x /usr/bin/fortune ]
then
	if [ -x /usr/local/bin/lolcat ]
	then
		if [ -x /usr/local/bin/cowsay ]
		then
			fortune -a | cowsay -f tux-stab | lolcat -F 1
		else
			fortune -a | lolcat -F 1
		fi
	else
		fortune -a
	fi
elif [ -x /usr/games/fortune ]
then
	if [ -x /usr/local/bin/lolcat ]
	then
		if [ -x /usr/local/bin/cowsay ] 
		then 
			fortune -a | cowsay -f tux-stab | lolcat -F 1
		else 
			fortune -a | lolcat -F 1
		fi
	else
		fortune -a 
	fi
fi

function 24bit() {
	# simple test to check for 24 bit color support
	# if the gradient is smooth, the true color support is working
	awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
	}'
}
