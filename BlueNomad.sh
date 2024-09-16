#!/bin/bash

# BlueNomad
# A tool which show the strenght and range of Bluetooth devices.
# Author - WireBits

usage() {
    echo -e "BlueNomad By WireBits"
    echo -e "Note : Run $0 as Root!"
    echo -e "Usage: $0 -i <hciX> -a <bdaddr>"
    echo -e "Options:"
    echo -e "  -i <hciX>      Local interface"
    echo -e "  -a <bdaddr>    Remote Device Address"
    echo -e "  -h             Show this help message and exit"
    exit 1
}

while getopts ":i:a:h" opt; do
    case ${opt} in
        i )
            HCI=$OPTARG
            ;;
        a )
            RM_ADDR=$OPTARG
            ;;
        h )
            usage
            ;;
        \? )
            echo "Invalid option: -$OPTARG" 1>&2
            usage
            ;;
        : )
            echo "Invalid option: -$OPTARG requires an argument" 1>&2
            usage
            ;;
    esac
done

if [ -z "$HCI" ] || [ -z "$RM_ADDR" ]; then
    usage
fi

RM_NAME="NONE"
LQ_PREV=255
PING_COUNT=0

RM_NAME=$(hcitool -i "$HCI" name "$RM_ADDR")

while true; do
    l2ping -i "$HCI" -c 1 "$RM_ADDR" | grep NULL
    LQ=$(hcitool -i "$HCI" lq "$RM_ADDR" | grep Link | awk '{print $3}')
    PING_COUNT=$((PING_COUNT + 1))
    clear
    echo -e "╔╗ ╦  ╦ ╦╔═╗╔╗╔╔═╗╔╦╗╔═╗╔╦╗"
    echo -e "╠╩╗║  ║ ║║╣ ║║║║ ║║║║╠═╣ ║║"
    echo -e "╚═╝╩═╝╚═╝╚═╝╝╚╝╚═╝╩ ╩╩ ╩═╩╝\n"
    echo -e "Locating Device Details"
    echo -e "Device Name : $RM_NAME"
    echo -e "Device MAC Address : $RM_ADDR\n"
    echo -e "Ping Count : $PING_COUNT\n"
    if [ -z "$LQ" ]; then
        echo "Connection Error!"
    else
        echo -e "Strenght               Link Quality"
        echo -e "--------               ------------"
        if [ $LQ -gt 230 ] && [ $LQ -lt 255 ]; then
            echo -e "GOOD                   $LQ/255"
        elif [ $LQ -gt 150 ] && [ $LQ -lt 230 ]; then
            echo -e "MODERATE               $LQ/255"
        elif [ $LQ -lt 150 ]; then
            echo -e "POOR                   $LQ/255"
        else
            echo -e "FULL                   $LQ/255"
        fi
        echo -e "\nRange\n---------------------------------------------------------"
        ranges=(
            "255|*"
            "245| *"
            "235|   *"
            "225|     *"
            "215|       *"
            "205|         *"
            "195|           *"
            "185|             *"
            "175|               *"
            "165|                 *"
            "155|                   *"
            "145|                     *"
            "135|                       *"
            "125|                         *"
            "115|                           *"
            "105|                             *"
            "95|                                *"
            "85|                                  *"
            "75|                                    *"
            "65|                                      *"
            "55|                                        *"
            "45|                                          *"
            "35|                                            *"
            "25|                                              *"
            "15|                                                *"
            "10|                                                  *"
            "5|                                                     *"
            "0|                                                       *"
        )
        for range in "${ranges[@]}"; do
            IFS='|' read -r boundary marker <<< "$range"
            if [ "$LQ" -ge "$boundary" ]; then
                echo -e "|$marker"
                break
            fi
        done
        echo -e "---------------------------------------------------------"
        LQ_PREV=$LQ
    fi
done
