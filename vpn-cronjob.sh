#!/bin/bash

tun_info=$(ip addr | grep inet.*tun0)
deluge_running=$(docker container inspect -f '{{.State.Running}}' deluge)

# check if tun0 net if is present and deluge container is running else if tun0 net if and deluge not running
# I don't want email every minute
if [[ -z $tun_info ]] && [[ "$deluge_running" = "true" ]]; then
  docker stop deluge
  docker stop sabnzbd
  docker stop bazarr
  docker stop sonarr
  docker stop radarr

  python3 ~/notify-vpn-down.py
elif [[ -n $tun_info ]] && [[ "$deluge_running" = "false" ]]; then
  docker start deluge
  docker start sabnzbd
  docker start bazarr
  docker start sonarr
  docker start radarr
fi
