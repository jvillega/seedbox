#!/bin/bash

tun_info=$(ip addr | grep inet.*tun0)
deluge_info=$(docker ps | grep deluge)

if [[ -z $tun_info ]] && [[ -n $deluge_info ]]; then
    docker stop deluge
    docker stop sabnzbd  
    docker stop bazarr
    docker stop sonarr
    docker stop radarr
    docker stop prowlarr
    docker stop flaresolverr    
    ip route flush table 42

    python3 PATH/notify-vpn-down.py
elif [[ -n $tun_info ]] && [[ -z $deluge_info ]]; then
    docker start deluge
    docker start sabnzbd
    docker start bazarr
    docker start sonarr
    docker start radarr
    docker start prowlarr
    docker start faresolverr
fi
