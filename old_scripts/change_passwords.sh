#!/usr/bin/env bash

PASSWORD_LENGTH=20
PASSWORD_DICTIONARY='a-zA-Z0-9'
DELIMITER=','

if [ "$(id -u)" -ne 0 ]; then
    echo "You must run this script as root!"
    exit
fi

# Info
# ------------------------
echo "Change Passwords Script..."
echo "Tested on: Ubuntu, Debian, CentOS, Gentoo, Alpine, OpenSUSE"
echo
echo "UFSIT: University of Florida, Student InfoSec Team"
echo "==========================================================="
echo

# Check Dependencies
# ------------------------
FILE_DEPENDENCIES=(
    "/dev/urandom"
    "/etc/passwd"
)
CMD_DEPENDENCIES=(
    "awk"
    "grep"
    "cut"
    "tr"
    "head"
    "chpasswd"
    "sort"
)
for file in "${FILE_DEPENDENCIES[@]}"; do
    if [ ! -e "$file" ]; then
        echo "ERROR: Missing File Dependency - $file... Not Continuing"
        exit
    fi
done
for cmd in "${CMD_DEPENDENCIES[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: Missing $cmd Dependency - $cmd... Not Continuing"
        exit
    fi
done

# echo -n "Use default settings? [y]/n: "
# read -r choice
# if  [ "$choice" != "y" ] && [ "$choice" != "" ]; then
#     echo -n "Password Length (int): "
#     read -r PASSWORD_LENGTH
#
#     # wtf??
#     # https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
#     case $PASSWORD_LENGTH in
#     ''|*[!0-9]*) echo "ERROR: Password Length is not an int! Exiting..."; exit ;;
#     esac
# fi
# echo

# User Discovery
# ------------------------
# Find users in the system by scanning /etc/passwd

# Scan for conventional accounts (UID >=1000)
conventional_users=($(awk -F: '($3 >= 1000) && ($3 < 65534) { print $1 }' /etc/passwd))
echo "[${#conventional_users[@]}] Conventional User Accounts (UID >= 1000):"
echo "${conventional_users[*]}"
echo

# Scan for accounts without "*/nologin", "*/false", "*/shutdown", "*/sync" shells, (likely login shells)
loginshell_users=($(grep -Ev \/nologin$\|\/false$\|\/shutdown$\|\/halt$\|\/sync$ /etc/passwd | awk -F: '{ print $1 }'))
echo "[${#loginshell_users[@]}] Accounts with login shells:"
echo "${loginshell_users[*]}"
echo

# Accounts with existing passwords
existingpassword_users=($(awk -F: '($2 !~ /^[!*]*$/) { print $1 }' /etc/shadow))
echo "[${#existingpassword_users[@]}] Accounts with existing passwords:"
echo "${existingpassword_users[*]}"
echo

# Scan for root accounts (UID 0/GID 0)
root_users=($(awk -F: '($3 == 0) { print $1 }' /etc/passwd))
echo "[${#root_users[@]}] Root Accounts (UID 0):"
echo "${root_users[*]}"
echo

# --------------------------------------------
# Merge all users, delete duplicates from list
# TODO: Make less complicated?
temp=("${root_users[@]}")
temp+=("${existingpassword_users[@]}")
temp+=("${loginshell_users[@]}")
temp+=("${conventional_users[@]}")

all_users=()
while IFS= read -r -d '' x; do
    all_users+=("$x")
done < <(printf "%s\0" "${temp[@]}" | sort -uz)
# --------------------------------------------

echo "Changing passwords for the users listed above [${#all_users[@]}]..."
echo -n "Continue? [y]/n: "
read -r choice
if  [ "$choice" != "y" ] && [ "$choice" != "" ]; then
    exit
fi
echo
echo "==========================================================="

echo
i=0
for user in "${all_users[@]}"; do
    password="$(head -c 250 /dev/urandom | tr -dc $PASSWORD_DICTIONARY | cut -c1-"$PASSWORD_LENGTH")"

    if ! echo "$user:$password" | chpasswd >/dev/null 2>&1; then
        echo "ERROR: Failed to change password for $user:$password"
    else
        i=$((i + 1))
    fi
    echo "$user$DELIMITER$password"
done
echo
echo "==========================================================="
echo
echo "Changed passwords for $i users. Copy the above output and submit a PCR"

# TODO: Automatically test credentials to verify password change worked
