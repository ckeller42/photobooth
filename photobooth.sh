#!/bin/bash 
#
# photobooth.sh
#  
# Use a fire tv remote in combination with gphoto
# to capture images and print them.
#


FPRESS="pressbutton.jpg"
FLOAD="loading.jpg"

function mydisplay {
    IMGNAME=$1
    open -a Xee $IMGNAME -g
    # make sure theat the terminal is on top
    osascript -e 'tell application "iTerm" to activate'
}

while true
do
    # display a "wait image"
    mydisplay $FPRESS

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
	mydisplay "error.jpg"
	echo "Waiting..."
	sleep 1
	FILENAME=""
    else
	FILENAME=`echo $FILENAME | grep "Saving file as" | awk '{print $4}'`
    	mydisplay $FILENAME
	#lp -o fit-to-page -d "" $FILENAME
    fi


   sleep 2
done


