#!/bin/bash

sudo openvpn --config /home/seeder/deluge-vpn-script/profile-userlocked.ovpn --auth-user-pass /home/seeder/deluge-vpn-script/vpn-credentials.txt --script-security 2 --up link_up_user_filter.sh
