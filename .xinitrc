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

autocutsel -fork &
autocutsel -selection PRIMARY -fork &
#urxvtd --opendisplay --fork --quiet &
xrandr --output DisplayPort-0 --left-of DVI-0 &
sh ~/.fehbg &
xscreensaver &
exec ssh-agent &
xset b off &
/home/mvoight/dwmstatus/dwmstatus &
exec dwm
#xmobar &
#exec xmonad
