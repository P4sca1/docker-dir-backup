FROM alpine:3.10

RUN apk add --no-cache --update bash tar

WORKDIR /scripts

COPY init.sh init.sh
COPY backup.sh backup.sh
COPY backup-exclude backup-exclude

RUN chmod +x init.sh && chmod +x backup.sh

ENV CRON_SCHEDULE="0 4 * * *" MAX_DAYS=7

CMD ["/bin/bash", "init.sh"]