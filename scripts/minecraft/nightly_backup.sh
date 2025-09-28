#!/bin/bash

DEST_DIR="$HOME/mcbackups"
REMOTE_DIR="/mnt/user/backbox/mcbackups/$(hostname)"

echo "Dest dir: $DEST_DIR"
echo "Remote dir: $REMOTE_DIR"

# These function will need additional lines for new servers in the future.
#
function servers_say() {
  docker exec --user 1000:1000 mc-endventure mc-send-to-console say "$1"
}

function servers_stop() {
  docker stop mc-endventure
}

function servers_start() {
  docker start mc-endventure
}
function do_backup() {
  tar --exclude="**/bluemap/*" -czvf "$DEST_DIR/$BACKUP_FILENAME" "mc/endventure"
}

# 60 second warning
servers_say "60 seconds until nightly backup!"
servers_say "The server will be offline until the backup is complete!"
sleep 50

# 10 second warning
servers_say "10 seconds until backup!! Servers are shutting down."
sleep 10

# stop servers
echo Stopping Servers
servers_stop

# Create the backup filename with current timestamp
TIMESTAMP=$(date +'%Y%m%d%H%M%S')
BACKUP_FILENAME="mc_$TIMESTAMP.tar.gz"

# Ensure the destination directories exists
echo Making dest directories
mkdir -p "$DEST_DIR"
mkdir -p "$REMOTE_DIR"

# Create the gzipped tarball
# Create it on the local storage so the server is down for the minimum amount of time
echo Creating the archive
cd "$HOME" || exit
do_backup

# start servers
echo Starting servers
servers_start

# copy to backup destination
echo Rsyncing
rsync --verbose --remove-source-files --bwlimit=50000 "$DEST_DIR/$BACKUP_FILENAME" "$REMOTE_DIR/$BACKUP_FILENAME"

# keep only the past 14 days of backups
echo Deleting old backups
find "$REMOTE_DIR" -type f -name "mc_*.tar.gz" -mtime +14 -exec rm {} \;
