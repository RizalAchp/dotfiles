#!/bin/sh -e

IMG=/tmp/screen_locked.png
# Take a screenshot
maim "$IMG"
# Pixellate it 10x
mogrify -scale 10% -scale 1000% "$IMG"
# Lock screen displaying this image.
i3lock -i "$IMG"
# Turn the screen off after a delay.
sleep 60; pgrep i3lock && xset dpms force off
rm -rf "$IMG"
