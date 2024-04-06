#!/bin/bash

# Check if Tilix process exists
if pgrep -x "tilix" > /dev/null; then
    # Get the ID of the Tilix window
    TERMINAL_WINDOW_ID=$(xdotool getactivewindow)

    # Close all open windows except the Tilix window
    wmctrl -l | awk -v term="$TERMINAL_WINDOW_ID" '$1 != term {print $1}' | xargs -I {} wmctrl -i -c {}
else
    # Close all open windows
    wmctrl -l | awk '{print $1}' | xargs -I {} wmctrl -i -c {}
fi

sudo poweroff
