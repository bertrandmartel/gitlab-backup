FROM ubuntu:latest

MAINTAINER bmartel.fr@gmail.com

# install cron, curl, jq, 7z, git
RUN apt-get update && apt-get -y install cron curl jq p7zip-full git rsyslog

ADD backup.sh /bin/backup.sh
RUN chmod 777 /bin/backup.sh

COPY backup-cron /etc/crontab
COPY start.sh /cron/start.sh

RUN chmod 777 /cron/start.sh
RUN chmod 644 /etc/crontab

ENV GITLAB_DOMAIN      gitlab.com
ENV GITLAB_PORT        443
ENV GITLAB_SSH_PORT    22
ENV KEY_SSH_RSA        "recommended"
ENV KEY_ECDSA          "recommended"
ENV KEY_ED25519        "recommended"
ENV PROJECT_MAX_NUMBER 300
ENV PRIVATE_TOKEN      "required"
ENV BACKUP_DIR         /home/backup
ENV GITLAB_USERNAME    "required"
ENV GITLAB_PASSWORD    "required"
ENV TMP_DIR            /tmp/repos
ENV RETAIN_TIME        30

CMD bash /cron/start.sh