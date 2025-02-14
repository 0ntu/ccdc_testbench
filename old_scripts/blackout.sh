#!/usr/bin/env bash
if [ "$(id -u)" -ne 0 ]; then
    echo "You must run this script as root!"
    exit
fi

# Info
# ------------------------
echo "Blackout Script..."
echo "Tested on: Ubuntu, Debian, CentOS, Gentoo, Alpine, OpenSUSE"
echo
echo "UFSIT: University of Florida, Student InfoSec Team"
echo "==========================================================="
echo

echo "WARNING: This script is NOT foolproof"
echo "Its possible to lock yourself out of the machine if you don't know what you're doing!"
echo "VERIFY the above rules are compatible with the current configuration"
echo
echo -n "Continue? [y]/n: "
read -r choice
if  [ "$choice" != "y" ] && [ "$choice" != "" ]; then
    exit
fi
