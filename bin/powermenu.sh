#!/usr/bin/env bash

DMENU_ARGS="dmenu -c -b -i -p"

confirm_exit() {
    echo -e "Yes\nNo\nCancel" | $DMENU_ARGS "Are you sure?: "
}

case "$(echo -e "Shutdown\nRestart\nLogout\nSuspend\nLock" | $DMENU_ARGS "Power:" -l 5)" in
    Shutdown)
        confirms=$(confirm_exit)
        [[ $confirms == "Yes"  ]] && exec systemctl poweroff || exit 0
        ;;
    Restart)
        confirms=$(confirm_exit)
        [[ $confirms == "Yes"  ]] && exec systemctl reboot || exit 0
        ;;
    Suspend)
        confirms=$(confirm_exit)
        [[ $confirms == "Yes"  ]] && exec systemctl suspend || exit 0
        ;;
    Logout)
        confirms=$(confirm_exit)
        [[ $confirms == "Yes"  ]] && killall dwm || exit 0
        ;;
    Lock)
        exec $HOME/.local/bin/lock.sh
        ;;
    *) exit 0;;
esac
