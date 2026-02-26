#!/bin/sh
set -e

users_conf="/etc/samba/users.conf"
uid_base=1000
gid_base=1000

# Auto-generate users.conf if SMB_USER_* variables are present
if env | grep -q '^SMB_USER_'; then
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

echo "[entrypoint] Starting wsdd..."
wsdd --shortlog &

echo "[entrypoint] Starting avahi-daemon..."
avahi-daemon --no-drop-root --daemonize --debug &

echo "[entrypoint] Starting Samba..."
exec /usr/bin/samba.sh "$@"
