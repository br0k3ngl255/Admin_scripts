#!/bin/bash 
set -x
#created by br0k3ngl@55
#date updated 30.01.14
#Version 2 of alarm clock

######################################################################
# i started this script at one evening when my phone was stolen      #
# and there was nobody to wake me up, it took me some time to figure #
# out how i'd wish to make it, but after several hours i was done    #
# and script was working.                                            # 
#			hope you'll enjoy it and as much i did.      #
######################################################################

##Variables--just vars to be used in functions to come.---------------------------------------------------------------------------##

alarmRing='' 
alarmTime=''
currentTime="`date +%k:%M`"


##Functions-----just like in every prgramming language - small functions to do the small job of getting,using and  exiting program.------##

function  playerChoise(){ #  in case there won't be VLC installed you could choose other player.
	alarmRing=`zenity --file-selection`
}

function  checkVLC(){ #checking player to play the alert/alarm.
status=0
	if [ -x /usr/bin/vlc ];then
		status=1
	else
		zenity --notify --text="you do not have VLC player installed. Please choose other player."
		sleep 5
			playerChoise
	fi
echo $status
}

function checkInput(){ #cheking time input to be corret.
Status=0
	if [[ "$alarmTime" =~ ^[1-2]?[0-9]\:[0-5][0-9]$ ]];then
		Status=0
	else
		Status=1
	fi
echo $Status
}

function getRing(){ # getting alarm/alert to wake you up.
	
	alarmRing=`zenity --file-selection `
}
 
function getAlarmTime(){ ##grabbing the time to awake you .

	alarmTime=`zenity --entry --text="please enter desired time to wake you up?"`
}


##Actions--- you can look at this section as a "main" of the script-> here is where functions are used to create "program".##

if [ `checkVLC` == 1 ];then 
	alarmPlay=/usr/bin/vlc
fi
	getAlarmTime 2> /dev/null
		
	if [ `checkInput` = 0 ];then
		zenity --notification --text=" ok will wake you up at $alarmTime" 2> /dev/null
	else
		zenity --error  --text=" wrong input check that you have inseted the time correctly " 2> /dev/null
			exit "1"
	fi
			getRing  2> /dev/null  

#************* this loop isn't perfect and within time it will be changed, until then -- keep tight over there*******************

while [ $currentTime != $alarmTime ];
	do
	 currentTime="`date +%k:%M`" #update the variable of time change
	 sleep 1 ##  DO NOT CHANGE THE VALUE - if must change not more then 15 - other wise it won't start the alarm.
	done

if [ $currentTime==$alarmTime ];then
	$alarmPlay $alarmRing > /dev/null 2> /dev/null & 
fi 
