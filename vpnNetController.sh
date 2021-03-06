#!/bin/bash
#
#creted by br0k3ngl2555
#date 06.22.2014
#
###############################################################################
#automation of ddns and hidemyass openvpn script
#usefull if you need these to start on your boot.
#for the moment for debian based only
# you need to use " insserv vpnNetController.sh" and thats it
###############################################################################

### BEGIN INIT INFO
# Provides:             OpenVPN, NoIP 
# Required-Start:       $remote_fs $syslog
# Required-Stop:        $remote_fs $syslog
# Default-Start:        2 3 4 5 
# Default-Stop:    
# Short-Description:    OpenVPN and NoIP client config and automation for lazy people
### END INIT INFO

set -x

##Vars~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
hmaConfig=''
noIPconfig=' -I tun0  -u XXXXXXXXXXX -p $$$$$$$$$$$$$$' #you need to put your hma usr/passwd here
##Funcs++++++++++++++++++++++++++++++++++++++



function checkNoIP(){
 if [ -f /usr/loca/bin/noip2 ];then
	cd /usr/src
		wget http://www.noip.com/client/linux/noip-duc-linux.tar.gz
		tar xvzf noip-duc-linux.tar.gz
			cd noip-*
				make && make install
fi
}

function checkVPN(){
cmd=`dpkg -l |grep openvpn > /dev/null;echo $? `
	if [ -f /usr/local/bin/hma-vpn.sh ] || [ $cmd=="1" ];then
		cd /usr/local/bin
		wget http://hmastuff.com/hma-vpn.sh
		chmod +X hma-vpn.sh	
	fi
}

#function netTest(){
#ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && echo "0" || echo "1"
#}

function loadNoIP(){
sleep 10
noip2 

}

function loadHMA(){ #this still needs debugging - because redirecting usr/paswd into the script doesn't works' yet ;usually you run the script manually and it will set username password and will fetch afterwords else this script won't work properly'
/usr/local/bin/hma-vpn.sh -p tcp Amsterdam  &

}

function runCheck(){
noipCmd=`ps aux |grep -v grep| grep noip2 > /dev/null;echo $? `
openvpnCmd=`ps aux |grep -v grep | grep openvpn > /dev/null ; echo $? `
	if [ $noipCmd== "0" ] || [ $openvpnCmd == "0" ];then
		echo "Already conected to reconnect kill the instance "
		exit
	fi
}

##Actions-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
netCMD=`ping -c 1 8.8.8.8 > /dev/null |echo $?`
if [ $netCMD != 0 ];then

checkNoIP 
	checkVPN
		runCheck
		sleep 20
	elif [ $EUID != 0 ];then
		echo " Be root or Get Chroot "
		exit
		else	
			runCheck
			           loadHMA
				intCMD=`ifconfig |cut -d " " -f  1|grep tun0 > /dev/null ;echo $?`
				openvpnLoad=`ps aux|grep -v grep| grep openvpn > /dev/null;echo $?`
			while [ $intCMD == "0" ] && [ $openvpnLoad == "0" ] # this is loop
   				do
#while (ps -A | grep -v grep | grep mySimulator > /dev/null); do sleep 1; done
					sleep 5
					if [ $intCMD=="0" ];then
						sleep 5
						break
					fi			
				   done
			loadNoIP
fi
