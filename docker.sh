# Create docker network so we can assign static IPs to the containers
sudo docker network create --subnet=172.18.0.0/16 --gateway=172.18.0.1 arrstack

# Radarr
sudo docker run --detach --restart unless-stopped --network=arrstack --ip=172.18.0.2 --publish 7878:7878 --name radarr -v PATH_TO_CONFIG/radarr:/config -v PATH_TO_DATA/data:/data -e PUID=UID -e PGID=GID ghcr.io/hotio/radarr:latest

# Sonarr
sudo docker run --detach --restart unless-stopped --network=arrstack --ip=172.18.0.3 --publish 8989:8989 --name sonarr -v PATH_TO_CONFIG/sonarr:/config -v PATH_TO_DATA/data:/data -e PUID=UID -e PGID=GID ghcr.io/hotio/sonarr:latest

# Bazarr
sudo docker run --detach --restart unless-stopped --network=arrstack --ip=172.18.0.4 --publish 6767:6767 --name bazarr -v PATH_TO_CONFIG/bazarr:/config -v PATH_TO_DATA/data:/data/media -e PUID=UID -e PGID=GID ghcr.io/hotio/bazarr:latest

# Sabnzbd
sudo docker run --detach --restart unless-stopped --network=arrstack --ip=172.18.0.5 --publish 8080:8080 --publish 9090:9090 --name sabnzbd -v PATH_TO_CONFIG/sabnzbd:/config -v PATH_TO_DATA/data/usenet:/data/usenet:rw -e PUID=UID -e PGID=GID ghcr.io/hotio/sabnzbd:latest

# Deluge
sudo docker run --detach --restart unless-stopped --network=arrstack --ip=172.18.0.6 --publish 8112:8112 --name deluge -v PATH_TO_CONFIG/deluge:/config -v PATH_TO_DATA/data/torrents:/data/torrents -e PUID=UID -e PGID=GID lscr.io/linuxserver/deluge:latest

# Prowlarr
sudo docker run --detach --restart unless-stopped --network=arrstack --ip=172.18.0.7 --publish 9696:9696 --name prowlarr -v PATH_TO_CONFIG/prowlarr:/config -v PATH_TO_DATA/data:/data -e PUID=UID -e PGID=GID ghcr.io/hotio/prowlarr:lastest

# Flaresolverr 
sudo docker run -detach --restart unless-stopped --network=arrstack --ip=172.18.0.8 --publish 8189:8191 --name flaresolverr -e LOG_LEVEL=info -v PATH_TO_CONFIG/flaresolverr ghcr.io/flaresolverr/flaresolverr:latest
