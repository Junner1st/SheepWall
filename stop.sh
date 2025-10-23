#!/usr/bin/env sh
# Exit on error
set -e

AP="ap0"

if [ "$(id -u)" -ne 0 ]; then
	echo "run with root privilege sudo ./start.sh"
	exec sudo sh "$0" "$@"
fi

docker compose down

nmcli device set "$AP" managed yes

iw dev

nmcli device status