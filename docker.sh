# Intructions for installing docker rootlesss
# https://docs.docker.com/engine/security/rootless/

# Once docker rootless is installed you could run this file as a bash scrips
docker run --detach --restart unless-stopped --publish 7878:7878 --name radarr -v /home/seeder/config/radarr:/config -v /home/seeder/data/:/data -e PUID=1000 -e PGID=1000 ghcr.io/hotio/radarr:latest

docker run --detach --restart unless-stopped --publish 8989:8989 --name sonarr -v /home/seeder/config/sonarr:/config -v /home/seeder/data/:/data -e PUID=1000 -e PGID=1000 ghcr.io/hotio/sonarr:latest

docker run --detach --restart unless-stopped --publish 6767:6767 --name bazarr -v /home/seeder/config/bazarr:/config -v /home/seeder/data/:/data/media -e PUID=1000 -e PGID=1000 ghcr.io/hotio/bazarr:latest

docker run --detach --restart unless-stopped --publish 8080:8080 --publish 9090:9090 --name sabnzbd -v /home/seeder/config/sabnzbd:/config -v /home/seeder/data/usenet:/data/usenet:rw -e PUID=1000 -e PGID=1000 ghcr.io/hotio/sabnzbd:latest

docker run --detach --restart unless-stopped --publish 8112:8112 -v /home/seeder/config/deluge:/config -v /home/seeder/data/torrents:/data/torrents -e PUID=1000 -e PGID=1000 lscr.io/linuxserver/deluge:latest
