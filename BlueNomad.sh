#!/bin/bash

# BlueNomad
# A tool which shows the strength and range of Bluetooth devices.
# Author - WireBits

green='\033[0;32m'
blue='\033[0;34m'
red='\033[0;31m'
yellow='\033[0;33m'
cyan='\033[0;36m'
reset='\033[0m'

logo() {
  echo -e "${blue}
  ╔╗ ╦  ╦ ╦╔═╗╔╗╔╔═╗╔╦╗╔═╗╔╦╗
  ╠╩╗║  ║ ║║╣ ║║║║ ║║║║╠═╣ ║║
  ╚═╝╩═╝╚═╝╚═╝╝╚╝╚═╝╩ ╩╩ ╩═╩╝
 +---------------------------+
       Author - WireBits
${reset}"
}

clear
logo

read -e -p $'[\033[0;32m*\033[0m] Enter Bluetooth Interface : ' btinterface
read -e -p $'[\033[0;32m*\033[0m] Enter Target MAC Address : ' btmacaddress

RM_NAME="NONE"
LQ_PREV=255
PING_COUNT=0

RM_NAME=$(hcitool -i "$btinterface" name "$btmacaddress")

while true; do
    l2ping -i "$btinterface" -c 1 "$btmacaddress" | grep NULL
    LQ=$(hcitool -i "$btinterface" lq "$btmacaddress" | grep Link | awk '{print $3}')
    PING_COUNT=$((PING_COUNT + 1))
    clear
    logo
    echo -e "${yellow}Locating Device Details${reset}"
    echo -e "${yellow}Device Name :${reset} ${cyan}$RM_NAME${reset}"
    echo -e "${yellow}Device MAC Address :${reset} ${cyan}$btmacaddress${reset}\n"
    echo -e "${yellow}Ping Count :${reset} ${green}$PING_COUNT${reset}\n"
    if [ -z "$LQ" ]; then
        echo -e "${red}Connection Error!${reset}"
    else
        echo -e "${yellow}Strength               Link Quality${reset}"
        echo -e "${yellow}--------               ------------${reset}"
        if [ $LQ -gt 230 ] && [ $LQ -lt 255 ]; then
            echo -e "${green}GOOD                   $LQ/255${reset}"
        elif [ $LQ -gt 150 ] && [ $LQ -lt 230 ]; then
            echo -e "${yellow}MODERATE               $LQ/255${reset}"
        elif [ $LQ -lt 150 ]; then
            echo -e "${red}POOR                   $LQ/255${reset}"
        else
            echo -e "${cyan}FULL                   $LQ/255${reset}"
        fi
        echo -e "\n${yellow}Range\n---------------------------------------------------------${reset}"
        ranges=(
            "255|${red}*${reset}"
            "245| ${red}*${reset}"
            "235|   ${red}*${reset}"
            "225|     ${red}*${reset}"
            "215|       ${red}*${reset}"
            "205|         ${red}*${reset}"
            "195|           ${red}*${reset}"
            "185|             ${red}*${reset}"
            "175|               ${red}*${reset}"
            "165|                 ${red}*${reset}"
            "155|                   ${red}*${reset}"
            "145|                     ${red}*${reset}"
            "135|                       ${red}*${reset}"
            "125|                         ${red}*${reset}"
            "115|                           ${red}*${reset}"
            "105|                             ${red}*${reset}"
            "95|                                ${red}*${reset}"
            "85|                                  ${red}*${reset}"
            "75|                                    ${red}*${reset}"
            "65|                                      ${red}*${reset}"
            "55|                                        ${red}*${reset}"
            "45|                                          ${red}*${reset}"
            "35|                                            ${red}*${reset}"
            "25|                                              ${red}*${reset}"
            "15|                                                ${red}*${reset}"
            "10|                                                  ${red}*${reset}"
            "5|                                                     ${red}*${reset}"
            "0|                                                       ${red}*${reset}"
        )
        for range in "${ranges[@]}"; do
            IFS='|' read -r boundary marker <<< "$range"
            if [ "$LQ" -ge "$boundary" ]; then
                echo -e "${blue}|${reset}$marker"
                break
            fi
        done
        echo -e "${yellow}---------------------------------------------------------${reset}"
        LQ_PREV=$LQ
    fi
done
