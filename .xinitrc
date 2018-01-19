#!/bin/sh
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /usr/local/etc/X11/xinit/xinitrc.d ] ; then
 for f in /usr/local/etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

export QT_QPA_PLATFORMTHEME=qt5ct
autocutsel -fork &
autocutsel -selection PRIMARY -fork &
#urxvtd --opendisplay --fork --quiet &
#xrandr --addmode DVI-0 1920x1080 &
#xrandr --output DVI-0 --mode 1920x1080 &
xrandr --output DisplayPort-0 --right-of DVI-0 &
#sh ~/.fehbg &
xscreensaver &
#ssh-agent &
#export SSH_AUTH_SOCK & 
#export SSH_AGENT_PID &
xset b off &
xset s off &
dwmstatus &
dbus-launch --exit-with-session --sh-syntax dwm
#xmobar &
#exec start-lumina-desktop
#exec xmonad
