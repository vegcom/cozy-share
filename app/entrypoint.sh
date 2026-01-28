#!/bin/sh

users_conf="/etc/samba/users.conf"

# Start UID/GID counters
uid_base=1000
gid_base=1000

# If any SMB_USER_* variables exist, generate users.conf
env | grep '^SMB_USER_' >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "# Auto-generated users" > "$users_conf"

    i=0
    for var in $(env | grep '^SMB_USER_' | sort | cut -d= -f1); do
        eval "user=\${$var}"
        username=$(echo "$user" | cut -d: -f1)
        password=$(echo "$user" | cut -d: -f2)

        uid=$((uid_base + i))
        gid=$gid_base
        group="smb"
        homedir="/storage"

        echo "$username:$uid:$group:$gid:$password:$homedir" >> "$users_conf"

        i=$((i + 1))
    done
fi

exec /usr/bin/samba.sh
