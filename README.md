# Seedbox
In this repository you can find all the instructions for setting up a seedbox. The programs will be run in a container  with all traffic going through an OpenVPN access server. With this setup you will still be able to access LAN devices such as TrueNAS.

I used a couple of guides to help come up with this.  
[https://wiki.servarr.com/docker-guide](https://wiki.servarr.com/docker-guide)  
[https://trash-guides.info/File-and-Folder-Structure/](https://trash-guides.info/File-and-Folder-Structure/)

I'd strongly encourage enabling SSH so you can connect to the seedbox easily. Having ability to have multiple terminals makes things so much easier.

### Useful commands
You need to make all .sh files executable. Use the below command on each file, if you want to change permissions you can change the number:
```
chmod 755 FILE
```
This will give owner read, write, execute and everyone else read, execute.

Use the below command to get your UID and GID which you will need later. It will probably be 1000.
```
id
```

## TrueNAS
We need to mount the NFS share from TrueNAS. This share should be owned by the same name, UID, GID as your linux user. This has instructions that worked for me [https://trash-guides.info/File-and-Folder-Structure/How-to-set-up/TrueNAS-Core/](https://trash-guides.info/File-and-Folder-Structure/How-to-set-up/TrueNAS-Core/). It is technically for TrueNAS Core but it should work. You don't need a shared group.

Create a directory in your home directory to mount the NFS share. I used data as the diretory.

You can use the below command to mount the NFS share
```
sudo mount -t nfs TRUENAS_IP:PATH_TO_NFS_SHARE MOUNT_PATH
```
For me the PATH_TO_NFS_SHARE needed to be an absolute path.

To mount the NFS share on restat or start add the following line to your /etc/fstab file. They are separated by tabs but spaces should work.
```
TRUENAS_IP:/PATH_TO_NFS_SHARE  MOUNT_PATH   nfs noauto,x-systemc.automount  0   0
```

## File Structure
Once the NFS share is mounted you need to create the file structure for everything. Here is the file structure, you can add more directories such as books, music. I'm only downloading movies and tv:
MOUNT_DIR
- torrents
    - movies
    - tv
- usenet
    - complete
        - movies
        - tv
    - incomplete
-  media
    - movies
    - tv

## Docker
We are going to install docker. You can find instructions at [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/). If you are using Debian 12 you can just run install-docker.sh.

We are going to need one more directory for container configs. I used config as the directory name in my home directory. Each container is going to need its' own directory in the config directory. You should have something similar to:
- config
    - deluge
    - sonarr
    - radarr
    - bazarr
    - sabnzbd
    - prowlarr
    - flaresolverr

In the repository there should be a file titled docker.sh. This file containes all the docker run commands but I'll include the commands below in case you want to run them one at a time or examine them. Repalce PATH_TO_CONFIG with the absolute path to your config directory, repalce PATH_TO_DATA with the absolute path to the data directory. If you named them something else use the absolute path to those.

It would be best practice if each container had an individual user but I'm the only one accessing this so I'm not worried about the increased security.
```
# Radarr
sudo docker run --detach --restart unless-stopped --publish 7878:7878 --name radarr -v PATH_TO_CONFIG/radarr:/config -v PATH_TO_DATA:/data -e PUID=UID -e PGID=GID ghcr.io/hotio/radarr:latest

# Sonarr
sudo docker run --detach --restart unless-stopped --publish 8989:8989 --name sonarr -v PATH_TO_CONFIG/sonarr:/config -v PATH_TO_DATA:/data -e PUID=UID -e PGID=GID ghcr.io/hotio/sonarr:latest

# Bazarr
sudo docker run --detach --restart unless-stopped --publish 6767:6767 --name bazarr -v PATH_TO_CONFIG/bazarr:/config -v PATH_TO_DATA:/data/media -e PUID=UID -e PGID=GID ghcr.io/hotio/bazarr:latest

# Sabnzbd
sudo docker run --detach --restart unless-stopped --publish 8080:8080 --publish 9090:9090 --name sabnzbd -v PATH_TO_CONFIG/sabnzbd:/config -v PATH_TO_DATA/usenet:/data/usenet:rw -e PUID=UID -e PGID=GID ghcr.io/hotio/sabnzbd:latest

# Deluge
sudo docker run --detach --restart unless-stopped --publish 8112:8112 --name deluge -v PATH_TO_CONFIG/radarr:/config -v PATH_TO_DATA/torrents:/data/torrents -e PUID=UID -e PGID=GID lscr.io/linuxserver/deluge:latest

# Prowlarr
sudo docker run --detach --restart unless-stopped --publish 9696:9696 --name prowlarr -v PATH_TO_CONFIG/prowlarr:/config -v PATH_TO_DATA:/data -e PUID=UID -e PGID=GID ghcr.io/hotio/prowlarr:lastest

# Flaresolverr 
sudo docker run -detach --restart unless-stopped --publish 8189:8191 --name flaresolverr -e LOG_LEVEL=info -v PATH_TO_CONFIG/flaresolverr ghcr.io/flaresolverr/flaresolverr:latest
```
If you want more info on the options in the commands check out [Docker's docs](https://docs.docker.com/).

You can check if the containers are running with:
```
sudo docker ps
```

You can now access any of the containers from another computer via web gui at IP_ADDR:PORT-OF-CONATINER

I've included some other useful files. You may not need them but I was constantly using them:
**stop-docker-containers.sh** stops all the containers. Add/remove based on the containers you are using.
**start-docker-containers.sh** start all containers. Add/remove based on the containers you are using.
**restart-docker-containers** restart all containers. Add/remove based on the containers you are using.
**prune-docker.sh** delete and remove all stopped containers. Be careful using this.

## Cronjob
We will create a cronjob to periodically check for a VPN connection. If no connection stop the containers and email about VPN being down. If VPN is down stop all cotainers and flush the ip route cache. If you don't flush the ip route cache the internet will stop working. If the VPN is up and containers are stopped start containers. This will run every minute so if you want to manually test that this script works set this up last.

In sudo-vpn-cronjob.sh update PATH to the absolute path of notify-vpn-down.py.

Update the info in notify-vpn-down.py with your sonic email address info. This python script handles the email notification when the vpn is down. Not best practice to save your password in plaintext.

To add a cronjob run:
```
sudo crontab -e
```
It will ask which editor to use. Nano is the easiest to use.

Add this to the end of the file:
```
* * * * * PATH/sudo_vpn_cronjob.sh
```

## VPN
This is originally from [https://github.com/bendikro/deluge-vpn](https://github.com/bendikro/deluge-vpn)

###
Relevant files: 
**vpn-crendentials.txt** - update this file with your vpn username and password. This will allow us to auto login to the vpn. Once again not best to save your password in plaintext.
**user_filter/vpn_base.sh** - In this file update NETIF with your network interface (ex: eth0, ens18). Run ip addr and look for the interface grabbing the local IP. Update VPNUSER with the name of your linux user.

You will want to save your openvpn client file to the deluge-vpn script directory. You can use the scp command to copy the file from one linux computer to another with:
```
scp OVPN_FILENAME linux-username@IP:~
```
This will save the file in the home directory of linux-username.

To start the vpn run the below command. Starting the VPN is going to take over your terminal. I'd suggest running it in the proxmox console. You can also run it in the background by hitting CTRL+Z then running the command bg. You will may need to stop the process later. I'm using the first option.
```
cd deluge-vpn-script
./deluge_vpn.sh
```

You can verify that the VPN is working by running the below command and looking for tun0:
```
ip addr
```

The internet will stop working if you disconnect from the VPN. If for some reason you want to reconnect run:
```
sudo ip route flush table 42
```

## What to do when the VPN goes down
You just need to start the VPN again. The cronjob will take care of starting the containers again.

## Connecting containers
For connecting deluge with radarr or any other containers you are going to need the IP the docker bridge gives the deluge container. Run:
```
sudo docker inspect deluge
```
You are looking for IPAddress under bridge. It will probably be 172.17.0.*

Info adding the NFS share and other settings with examples can be found at [https://trash-guides.info/File-and-Folder-Structure/Examples/](https://trash-guides.info/File-and-Folder-Structure/Examples/). Just make sure you are updating paths.
