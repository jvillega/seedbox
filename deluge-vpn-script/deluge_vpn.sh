#!/bin/bash

sudo openvpn --config PATH/deluge-vpn-script/profile-userlocked.ovpn --auth-user-pass PATH/deluge-vpn-script/vpn-credentials.txt --script-security 2 --up link_up_user_filter.sh
