#!/bin/bash

tun_info=$(ip addr | grep inet.*tun0)
deluge_info=$(su -c "/home/seeder/bin/docker ps" seeder | grep deluge)

if [[ -z $tun_info ]] && [[ -n $deluge_info ]]; then
    su -c "/home/seeder/bin/docker stop deluge" seeder
    su -c "/home/seeder/bin/docker stop sabnzbd" seeder  
    su -c "/home/seeder/bin/docker stop bazarr" seeder
    su -c "/home/seeder/bin/docker stop sonarr" seeder
    su -c "/home/seeder/bin/docker stop radarr" seeder
    
    ip route flush table 42

    python3 /home/seeder/notify-vpn-down.py
elif [[ -n $tun_info ]] && [[ -z $deluge_info ]]; then
    su -c "/home/seeder/bin/docker start deluge" seeder
    su -c "/home/seeder/bin/docker start sabnzbd" seeder
    su -c "/home/seeder/bin/docker start bazarr" seeder
    su -c "/home/seeder/bin/docker start sonarr" seeder
    su -c "/home/seeder/bin/docker start radarr" seeder
fi
