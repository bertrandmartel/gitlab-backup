#!/bin/bash

export FILENAME=backup-$(date '+%y-%m-%d').7z

ssh-keyscan -p $GITLAB_SSH_PORT $GITLAB_DOMAIN >> gitlabKey

if grep -q "$KEY_SSH_RSA" gitlabKey && grep -q "$KEY_ECDSA" gitlabKey && grep -q "$KEY_ED25519" gitlabKey;
then
    echo "[ OK ] All key verified"
else
    exit 1
fi

mkdir -p ~/.ssh

ssh-keyscan -p $GITLAB_SSH_PORT $GITLAB_DOMAIN >> ~/.ssh/known_hosts

rm -rf $TMP_DIR && mkdir -p $TMP_DIR && cd $TMP_DIR

curl -s  "https://$GITLAB_DOMAIN:$GITLAB_PORT/api/v4/projects?private_token=$PRIVATE_TOKEN&page=1&per_page=$PROJECT_MAX_NUMBER&owned=true" | \
    jq '.[].http_url_to_repo' | \
    sed "s/https:\/\//https:\/\/$GITLAB_USERNAME:$GITLAB_PASSWORD@/g" | \
    xargs -P10 -I{} git clone {}

7z a -t7z $FILENAME
mkdir -p $BACKUP_DIR && cp $FILENAME $BACKUP_DIR/

find $BACKUP_DIR/* -mtime +$RETAIN_TIME -exec rm {} \;
