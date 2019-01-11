#!/bin/bash

echo "$CRON_SCHEDULE /bin/bash /scripts/backup.sh \n" | crontab -

crond -f