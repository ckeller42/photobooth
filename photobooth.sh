#!/bin/bash  
#
# photobooth.sh
#  
# Use a fire tv remote in combination with gphoto
# to capture images and print them.
#
# Intructions to connect a fire tv remote see:
# http://lipflip.org/node/2106
#
#
# Make sure you have a running gphoto2 installation.
# e.g. install it with: sudo port install gphoto2
# To prevent Mac OS X from claiming PTP cameras see:
# https://github.com/mejedi/mac-gphoto-enabler.git
#
# 2015-07-19 Christoph G. Keller <christoph.keller@gmx.net>

if [ `uname` != "Darwin" ];
then
    echo " :-( currently only working for Mac Os X"
    exit 5
fi


FPRESS="pressbutton.jpg"
FLOAD="loading.jpg"
FERROR="error.jpg"

# which printer to use
# you can get  list of names using: lpstat -p
# if not set, printing is disabled
PRINTERNAME="Canon_CP910" 


# name of the terminal application
TERMAPP="iTerm"

# app to use for displaying
IMGAPP="Xee"
function mydisplay {
    IMGNAME=$1
    open -a $IMGAPP $IMGNAME -g
}

# check some system settings
type gphoto2 > /dev/null || \
    echo "Please install gphoto2. sudo port install gphoto2"

while true
do
    # display a "wait image"
    mydisplay $FPRESS

    # make sure theat the terminal is on top
    osascript -e "tell application \"$TERMAPP\" to activate"

    # The fire tv remote send arrow keys and return.
    # We do want to trigger a command on any of those keys
    echo "Waiting for keypress"
    read -n3

    # tell the user what is happening
    ( sleep 1; mydisplay $FLOAD) &

    echo "Got key event"
    # run gphoto to capture and download the image
    FILENAME=`gphoto2 --capture-image-and-download --filename %Y%m%d%H%M%S.jpg`
    
    if [ $? -ne 0 ]; then
	echo "Error running gphoto"
	echo $FILENAME
	sleep 1
	mydisplay $FERROR
	echo "Waiting..."
	sleep 2
	FILENAME=""
    else
	FILENAME=`echo $FILENAME | grep "Saving file as" | grep -o -E "[0-9]{14}.jpg"`
    	mydisplay $FILENAME
	if [ ! -z "$PRINTERNAME" ]; then
	    lp -o media=a6 -o fit-to-page -d "$PRINTERNAME" $FILENAME
	fi
	sleep 5
    fi

done


exit 0
