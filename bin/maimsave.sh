#!/usr/bin/env bash

DIR_OUTPUT="$HOME/Pictures/Screenshots/$(date +%Y_%m_%d)"
OUTPUT="${DIR_OUTPUT}/$(date +%H%M%S).png"

full() {
    maim -q ${OUTPUT};
    cat ${OUTPUT} | xclip  -selection clipboard -target image/png;
    notify-send "Fullscreen Screenshots" "Saved to ${OUTPUT} and Copied to clipboard";
}
sel() {
    maim -s -q ${OUTPUT};
    cat ${OUTPUT} | xclip  -selection clipboard -target image/png;
    notify-send "Selection Screenshots" "Saved to ${OUTPUT} and Copied to Clipboard";
}

help() {
    echo "run with maimsave [ARGUMENTS]"
    echo "example: maimsave ssfull"
    echo "\
ARGUMENTS:
    ssfull => Fullscreen Screenshots
    sssave => Selection Screenshots and save
    sscopy => Selection Screenshots but on clipboard
"
    exit 0
}

[[ -d "$DIR_OUTPUT" ]] || mkdir -p $DIR_OUTPUT

"$@"
