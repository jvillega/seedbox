#!/bin/bash

# To test mounting smb fileshare use
sudo mount -t cifs -o vers=3.0,username=SMB_USERNAME,password=SMB_USER_PASSWORD //HOSTNAME/SHARE PATH_TO_MOUNT_DIR/

# To un mount use
sudo umount data

# Same as the above test but using file with the crednetials
sudo mount -t cifs -o credentials=PATH_TO_CREDENTIALS_FILE //HOSTNAME/SHARE PATH_TO_MOUNT_DIR/

sudo umount data

# line to add to /etc/fstab to auto mount smb share
# //HOSTNAME/SHARE    PATH_TO_MOUNT_DIR  cifs    x-systemd.automount,noserverino,noauto,vers=3.0,crendentials=PATH_TO_CREDENTIALS_FILE,iocharset=utf8,sec=ntlmv2,dir_mode=0775,uid=1000,gid=1000 0   0

sudo echo "//HOSTNAME/SHARE    PATH_TO_MOUNT_DIR  cifs    x-systemd.automount,noserverino,noauto,vers=3.0,crendentials=PATH_TO_CREDENTIALS_FILE,iocharset=utf8,sec=ntlmv2,dir_mode=0775,uid=1000,gid=1000 0   0" >> /etc/fstab
sudo mount -t nfs 192.168.1.204:/mnt/NAS/Jellyfin data
