#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
xsetroot -cursor_name left_ptr &
#xcompmgr &
libinput-gestures &
hsetroot -solid #000000
xscreensaver &
#exec xmonad
#exec i3
#exec gnome-session
#compton -b

#xrandr --setprovideroutputsource modesetting NVIDIA-0
#xrandr --auto

exec awesome
#exec gnome-session
