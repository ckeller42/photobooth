#!/bin/bash -x
#
# photobooth.sh
#  
# Use a fire tv remote in combination with gphoto
# to capture images and print them.
#


FPRESS="warte.png"
FLOAD="lade.png"
WAITTIME="2s"



while true
do
    # display a "wait image"
    open -a Xee $FPRESS -g

    # The fire tv remote send arrow keys and return.
    # We do want to trigger a command on any of those keys
    read -n3

    # tell the user what is happening
    ( sleep 2s;open -a Xee $FLOAD -g ) &

    # run gphoto to capture and download the image
    FILENAME=`gphoto2 --capture-image-and-download --filename %Y%m%d%H%M%S.jpg | grep "Saving file as" `
    FILENAME=`echo $FILENAME | awk '{print $4}'`
    
    
    #
    # I really would have loved to use a X11 image viewer
    # but osx is to stupid to work with wmctrl or have a "keep window focus"
    # function....
    # So we use open with -g
    #
    #screen_size=`xdpyinfo | sed '/dimensions:/!d;s/^[^0-9]*//;s/ pixels.*//'`
    #(display  -size $screen_size  $FILENAME) &
    #(feh --auto-zoom --geometry  $screen_size) &
    #mypid=$!
    #sleep 5s
    #kill -9 $mypid


    open -a Xee $FILENAME -g
    sleep $WAITTIME
done


