#!/bin/bash
set -x 
function create (){
touch /etc/init.d/tabfix
chmod +x /etc/init.d/tabfix

echo -e "# Start synclient edit. \n
#
### BEGIN INIT INFO\n
# Provides:          right click option on debian based OS. \n
# Required-Start:    $remote_fs $syslog $time \n
# Required-Stop:     $remote_fs $syslog $time \n
# Should-Start:      $network $named slapd autofs ypbind nscd nslcd \n
# Should-Stop:       $network $named slapd autofs ypbind nscd nslcd \n
# Default-Start:     2 3 4 5 \n
# Default-Stop:\n
# Short-Description: Regular background program processing daemon \n
# Description:       cron is a standard UNIX program that runs user-specified \n
#                    programs at periodic scheduled times. vixie cron adds a \n
#                    number of features to the basic UNIX cron, including better \n
#                    security and more powerful configuration options. \n
### END INIT INFO \n" >> /etc/init.d/tabfix

echo -e "
\n\tif egrep -iq 'touchpad' /proc/bus/input/devices; then
    \n\t\tsynclient VertEdgeScroll=1 &
     \n\t\tsynclient TapButton1=1 &
     \n\t\tsynclient ClickPad=1
    \n\t\tsynclient RightButtonAreaLeft=1630
    \n\t\tsynclient RightButtonAreaRight=3300
    \n\t\tsynclient RightButtonAreaTop=1500
    \n\t\tsynclient RightButtonAreaBottom=1800
 \n\tfi
" >> /etc/init.d/tabfix
}

function checkOS(){
cmd=`lsb_release -a|awk {'print $2'}|grep -E "Debian|Ubuntu|Mint|Peppermint" &> /dev/null  2> /dev/null ;echo $?`
	if [ -e /etc/debian_version ] || [ $cmd == "0" ];then
		botMngr='insserv -d'
	elif [ -e /etc/redhat-release ];then
		botMngr='chkonfig --add'
	else
		echo "NOT Supported yet"
		exit
	fi 
}

#-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
 if [ $EUID == "0" ];then
	create
		checkOS
			$botMngr /etc/init.d/tabfix
else
	echo " use root please"
	exit
fi

