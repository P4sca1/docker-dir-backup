#!/bin/bash

FOLDERS=()
#https://stackoverflow.com/questions/23356779/how-can-i-store-find-command-result-as-arrays-in-bash
while IFS= read -r -d $'\0'; do
    FOLDERS+=("$REPLY")
done < <(find /data/* -maxdepth 0 -type d -print0)

for FOLDER in "${FOLDERS[@]}"; do
	BASENAME=$(basename $FOLDER)

    #remove  backups older than 7 days
    echo "Removing old Backups for '$FOLDER' ..."

    find /backup/$BASENAME -maxdepth 1 -type f -ctime +${MAX_DAYS} -exec rm {} \;

    echo "Backing up contents of '$FOLDER' ..."

    NOW=$(date +%Y-%m-%d_%H-%M)
    BACKUPDIR="/backup/$BASENAME"

    mkdir -p $BACKUPDIR
    tar --create --gzip --file=$NOW.tar.gz --exclude-from /scripts/backup-exclude --directory $FOLDER . 
    chmod 700 $NOW.tar.gz

    cp $NOW.tar.gz $BACKUPDIR/$NOW.tar.gz
    rm $NOW.tar.gz
done

echo "Backup finished!"