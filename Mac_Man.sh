#!/usr/bin/env bash
#set -x
###############################################################################
#Purpose :
#         get mac address and check if it located in  db (nmap mac prefixes)
#        TODO - needs lil bit debugging and scenarious test
###############################################################################
###Vars------------------------------------------------------------------------
db='/usr/share/nmap/nmap-mac-prefixes'
#rundbchk=`cat $db`
##funcs+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

dbChk(){
cmd=dpkg -l |grep -w "nmap" > /dev/null ; echo $?
if [ -e $db ] || [ $cmd == "0" ];then
    true
else
    if [ ! -e /etc/debian_version ];then
        echo -e "Can not Run the script, NEEDS TO BE DEBIAN BASED OS"
    else
           echo"No DB found, Trying to FIX....";
            apt-get install nmap -y &> /dev/null 2> /dev/null
                if [ `echo $?` == "0" ];then
                    echo "FIXED !!!!"
                else
                    echo "Cound NOT FIX ....";exit
                fi
    fi
fi
    }
usage (){
echo " Mac_Man.Py -m <MAC_ADDRESS>"
    }
runDbChk(){
grep -n `echo "${macAddr^^}"|cut -d ":" -f 1,2,3|tr -d ':'` /usr/share/nmap/nmap-mac-prefixes
}
###Main ======================================================================
while getopts "m:" OPTIONS; do
   case ${OPTIONS} in
      m ) macAddr=$OPTARG  ;;
      * ) echo "Unknown option.";;   # Default  #this belongs to CASE :
   esac
done
if [ $EUID != "0" ];then
    echo "Get A ROOT";exit
else
    if [[ $# == 0 ]];then
        usage
    else
         runDbChk
    fi
fi