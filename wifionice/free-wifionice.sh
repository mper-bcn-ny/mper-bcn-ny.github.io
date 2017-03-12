#! /bin/bash


host=www.wifionice.de

bridge=`ip route get $(dig +short $host) | awk -n '/ br-/{ print $3}'`

if [ "" != "$bridge" ] ; then
    echo Found bridge $bridge for routing to $host. You may have to enter your pasword below to take it down. 
    sudo sudo ifconfig $bridge down
    sudo brctl delbr $bridge
else 
    echo No bridge found for routing to $host:
    ip route get $(dig +short $host)
fi
