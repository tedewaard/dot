[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

#Status bar: dwm-bar
/home/tedewaard/dwm-bar/dwm_bar.sh &

# Statusbar loop
#while true; do
 #  xsetroot -name "$(date +"%A, %B %d - %H:%M")"
  # sleep 10s    # Update time every minute
# +%A, %B 5d - %H:%M
#done &

#Set background image
~/.fehbg &

#Start picom
picom &

flameshot &
exec dwm
