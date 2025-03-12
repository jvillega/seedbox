# Seedbox
In this repository you can find all the instructions for setting up a seedbox. The programs will be run in a container  with all traffic going through an OpenVPN access server. With this setup you will still be able to access LAN devices such as TrueNAS.

I used a couple of guides to help come up with this.  
[https://wiki.servarr.com/docker-guide](https://wiki.servarr.com/docker-guide)  
[https://trash-guides.info/File-and-Folder-Structure/](https://trash-guides.info/File-and-Folder-Structure/)

### Useful commands
You need to make all .sh files executable. Use the below command on each file:
```
chmod 755 FILE
```
This will give owner read, write execute and everyone else read and execute.

## TrueNAS
We need to mount the SMB share from TrueNAS.

Create a directory in your home directory to mount the SMB share. I used data as the diretory.

#### Relevant Files:
**.smbcrendentials** - update SMB_USER and SMB_USER_PASSWORD in this file to your SMB share user and password. This file allows us to auto mount the share on computer startup.

In the below commands replace SMB_USERNAME with your SMB share user, SMB_USER_APSSWORD with your SMB share user password, HOSTNAME with the IP of TrueNAS, SHARE with the name of the share and PATH_TO_MOUNT_DIR with the directory of where you want to mount the SMB share, PATH_TO_CREDENTIALS_FILE with the absolute path to the .smbcrendentials file, USER_ID with your uid, GROUP_ID with your gid.
If you are not sure what your uid and gid are you can run:
```
id
```

You can unmount the SMB share with:
```
sudo umount PATH_TO_MOUNT_DIR
```

You can use the below command to test mounting the SMB share. Once mounted check the directory then unmount:
```
sudo mount -t cifs -o vers=3.0,username=SMB_USERNAME,password=SMB_USER_PASSWORD //HOSTNAME/SHARE PATH_TO_MOUNT_DIR/
```

You can use the below command to test mounting the SMB share using the .smbcredentials file. Once mounted check the directory then unmount:
```
sudo mount -t cifs -o vers=3.0,credentials=PATH_TO_CREDENTIALS_FILE //HOSTNAME/SHARE PATH_TO_MOUNT_DIR/
```

Once those commands work add this to your /etc/fstab file.
```
//HOSTNAME/SHARE    PATH_TO_MOUNT_DIR   cifs    x-systemd.automount,noserverino,noauto,vers=3.0,credentials=PATH_TO_CREDENTIALS_FILE,iocharset=utf9,sec=ntlmv2,dir_mode=0775,uid=USER_ID,gid=GROUD_ID   0   0
```

## File Structure
Once the SMB share is mounted you need to create the file structure for everything. Here is the file structure, you can add more directories such as books, music. I'm only downloading movies and tv:
MOUNT_DIR
    torrents
        movies
        tv
    usenet
        complete
            movies
            tv
        incomplete
    media
        movies
        tv

## Docker
We are going to install rootless docker so we can stop containers without having to use sudo. This makes it sigfincantly easier to do it in a cronjob. Instructions can be found at:
[https://docs.docker.com/engine/security/rootles](shttps://docs.docker.com/engine/security/rootless)

We are going to need one more directory for container configs. I used config as the directory name in my home directory. Each container is going to need its' own directory in the config directory. You should have something similar to:
config
    deluge
    sonarr
    radarr
    bazarr
    sabnzbd

In the repository there should be a file titled docker.sh. This file containes all the docker run commands but I'll include the commands below in case you want run them run at a time or examine them. I'm assuming you are using data to save all the torrent stuff and config for the container configurations. If you are not you will need to update PATH_TO_CONFIG and PATH_TO_DATA. Replace UID and GID with your uid and gid which you should already have. I have no idea how to use these programs or even what they do other then deluge.
```
# Radarr
docker run --detach --restart unless-stopped --publish 7878:7878 --name radarr -v PATH_TO_CONFIG/radarr:/config -v PATH_TO_DATA/data:/data -e PUID=UID -e PGID=GID ghcr.io/hotio/radarr:latest

# Sonarr
docker run --detach --restart unless-stopped --publish 8989:8989 --name sonarr -v PATH_TO_CONFIG/sonarr:/config -v PATH_TO_DATA/data:/data -e PUID=UID -e PGID=GID ghcr.io/hotio/sonarr:latest

# Bazarr
docker run --detach --restart unless-stopped --publish 6767:6767 --name bazarr -v PATH_TO_CONFIG/bazarr:/config -v PATH_TO_DATA/data:/data/media -e PUID=UID -e PGID=GID ghcr.io/hotio/bazarr:latest

# Sabnzbd
docker run --detach --restart unless-stopped --publish 8080:8080 --publish 9090:9090 --name sabnzbd -v PATH_TO_CONFIG/sabnzbd:/config -v PATH_TO_DATA/data/usenet:/data/usenet:rw -e PUID=UID -e PGID=GID ghcr.io/hotio/sabnzbd:latest

# Deluge
docker run --detach --restart unless-stopped --publish 8112:8112 --name deluge -v PATH_TO_CONFIG/radarr:/config -v PATH_TO_DATA/data/torrents:/data/torrents -e PUID=UID -e PGID=GID lscr.io/linuxserver/deluge:latest
```
If you want more info on the options in the commands check out [Docker's docs](https://docs.docker.com/).

You can check if the containers are running with:
```
docker ps
```

You can now access any of the containers from another computer via web gui at IP_ADDR:PORTOFCONATINER

## Cronjob
We will create a cronjob to periodically check for a VPN connection. If no connection stop the containers and email about VPN being down. Ideally we would also clear the ip route table, restart the vpn, then start the containers once the VPN is connected. I could figure out how to do that. My biggest issue was running commands without having to enter in the sudo password.

To add a cronjob run:
```
crontab -e
```
It will ask which editor to use. Nano is the easiest to use.

Add this to the end of the file:
```
* * * * * PATH_TO_VPN_CRONJOB.SH
```

## VPN
This is originally from [https://github.com/bendikro/deluge-vpn](https://github.com/bendikro/deluge-vpn)

###
Relevant files:
**vpn-crendentials.txt** - update this file with your vpn username and password. This will allow us to auto login to the vpn.
**user_filter/vpn_base.sh** - In this file update NETIF with your network interface (ex: eth0, ens18). Run ip addr and look for the interface grabbing the local IP. Update VPNUSER with the name of your linux user.

To start the vpn run the below command.
```
PATH_TO_DELUGE-VPN-SCRIPT/deluge_vpn.sh
or if you are in deluge-vpn-script
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
Make sure docker containers are stopped. Start the VPN again following the VPN section. Then run start-docker-containers.sh to start all the containers. You are going to need to start the containers in another window so I recommend SSHing into the server form another computer.
