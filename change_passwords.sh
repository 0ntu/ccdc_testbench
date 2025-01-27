#!/usr/bin/env bash

PASSWORD_LENGTH=15
PASSWORD_DICTIONARY='a-zA-Z0-9'

if [ "$(id -u)" -ne 0 ]; then
    echo "You must run this script as root!"
    exit
fi

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
)
for file in "${FILE_DEPENDENCIES[@]}"; do
    if [ ! -e "$file" ]; then
        echo "ERROR: Missing File Dependency - $file... Not Continuing"
        exit
    fi
done
for cmd in "${CMD_DEPENDENCIES[@]}"; do
    if ! command -v "$cmd" 2>&1 >/dev/null; then
        echo "ERROR: Missing $cmd Dependency - $cmd... Not Continuing"
        exit
    fi
done

# Change Passwords
# ------------------------
# Find users in the system by scanning /etc/passwd
# for accounts without "*/nologin" or "*/false" shells
echo
i=0
for user in $(grep -Ev \/nologin$\|\/false$\|\/shutdown$\|\/halt$ /etc/passwd | awk '{split($0,a,":");print a[1]}'); do
    i=$((i + 1))
    password="$(head -c 100 /dev/urandom | tr -dc $PASSWORD_DICTIONARY | cut -c1-$PASSWORD_LENGTH)"
    echo "$user,$password"
    if ! echo "$user:$password" | chpasswd >/dev/null 2>&1; then
        echo "ERROR: Failed to change password for $user:$password"
    fi
done
echo
echo "Changed passwords for $i users. Copy the above output and submit a PCR"

# TODO: Automatically test credentials to verify password change worked
