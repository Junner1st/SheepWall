#!/usr/bin/env sh
set -e

AP="ap0"

if [ "$(id -u)" -ne 0 ]; then
	echo "run with root privilege sudo ./start.sh"
	exec sudo sh "$0" "$@"
fi

docker compose down
nmcli device set "$AP" managed no

docker compose up --build -d

iw dev