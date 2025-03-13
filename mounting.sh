#!/bin/bash

# test mounting nfs share
# sudo mount -t nfs 192.168.1.204:PATH_TO_NFS_SHARE MOUNT_PATH

# line to add to /etc/fstab to auto mount smb share
# //HOSTNAME/SHARE    PATH_TO_MOUNT_DIR  cifs    x-systemd.automount,noserverino,noauto,vers=3.0,crendentials=PATH_TO_CREDENTIALS_FILE,iocharset=utf8,sec=ntlmv2,dir_mode=0775,uid=1000,gid=1000 0   0

sudo echo "192.168.1.204:PATH_TO_NFS_SHARE MOUNT_PATH nfs" >> /etc/fstab

# sudo echo "//HOSTNAME/SHARE    PATH_TO_MOUNT_DIR  cifs    x-systemd.automount,noserverino,noauto,vers=3.0,crendentials=PATH_TO_CREDENTIALS_FILE,iocharset=utf8,sec=ntlmv2,dir_mode=0775,uid=1000,gid=1000 0   0" >> /etc/fstab

