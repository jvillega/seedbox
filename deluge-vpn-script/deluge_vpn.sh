#!/bin/bash
#
sudo openvpn --config PATH_TO_VPN_USER_FILE --script-security 2 --up link_up_user_filter.sh
