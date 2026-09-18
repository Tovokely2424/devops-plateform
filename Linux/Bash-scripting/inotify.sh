#!/bin/bash

WATCH_DIR="/home/$USER/Documents/Github/hotel-booking-devops-journey/kubernetes/"

inotifywait -m -r \
    -e close_write,create,delete,move \
    --format '%w|%e|%f' \
    "$WATCH_DIR" |
while IFS='|' read -r path event file
do
    if [[ "$event" == *"CLOSE_WRITE"* ]]; then
        echo "[WATCHER] Change detected: $path$file"
        echo "[SYNC] Synchronizing..."

        rsync -av "$WATCH_DIR/" devopslab:~/cobeil/dev/kubernetes-labs/vengineers/

        echo "[SYNC] Done"
        echo "--------------------------------"
    fi
done
