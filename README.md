# Gitlab Backup script

[![Build Status](https://travis-ci.org/bertrandmartel/gitlab-backup.svg?branch=master)](https://travis-ci.org/bertrandmartel/gitlab-backup) [![](https://images.microbadger.com/badges/version/bertrandmartel/gitlab-backup.svg)](https://microbadger.com/images/bertrandmartel/gitlab-backup) [![](https://images.microbadger.com/badges/image/bertrandmartel/gitlab-backup.svg)](https://microbadger.com/images/bertrandmartel/gitlab-backup)

A dockerized Gitlab backup script to :
* retrieve all projects for a specific user in a CRON every day
* backup it
* remove too old backup (> retaining time)

## Configuration

Edit `vars-template` (environment variables) : 


| Variable name                    |  description       | default value                                      |
|----------------------------------|---------------------------------|---------------------------------------|
| KEY_SSH_RSA                      | SSH RSA key |   |
| KEY_ECDSA                        | SSH ECDSA key |     |
| KEY_ED25519                      | SSH ED25519 key  |  |
| PRIVATE_TOKEN                    | token used to call Gitlab API (personnal access token) | |
| GITLAB_USERNAME                  | gitlab username for retrieving individual repository | |
| GITLAB_PASSWORD                  | gitlab password for retrieving individual repository | |
| GITLAB_DOMAIN                    | Gitlab server domain name   | gitlab.com |
| GITLAB_PORT                      | port to be used for Gitlab API  | 443 |
| GITLAB_SSH_PORT                  | ssh port | 22 |
| PROJECT_MAX_NUMBER               | max number of repos to be backed up | 300 |
| BACKUP_DIR                       | directory when backup projects are transfered | /home/backup |
| RETAIN_TIME                      | retaining time in days | 30 |

`KEY_SSH_RSA`,`KEY_ECDSA` and `KEY_ED25519` should be specified to prevent man-in-the-middle attack, you can get those with :

```
ssh-keyscan -p $GITLAB_SSH_PORT $GITLAB_DOMAIN
```

`PRIVATE_TOKEN` is a personnal access token

## Standalone script

```
source vars-template
./backup.sh
```

## Docker

```
docker run -e "GITLAB_DOMAIN=my.gitlab.com" \
           -e "KEY_SSH_RSA=ssh-rsa XXXXXXX" \
           -e "KEY_ECDSA=ecdsa-sha2-nistp256 XXXXXX" \
           -e "KEY_ED25519=ssh-ed25519 XXXXXXXXXXXXXXx" \
           -e "PRIVATE_TOKEN=xZqsf-azsdllqmoaze" \
           -e "GITLAB_USERNAME=john" \
           -e "GITLAB_PASSWORD=changeme" \
           -v /home/user/backup:/home/backup bertrandmartel/gitlab-backup
```

## Docker-compose

```
source vars-template
envsubst < docker-compose-template.yml > docker-compose.yml
docker-compose up
```

## Docker-cloud

```
source vars-template
envsubst < stackfile-template.yml > stackfile.yml
```

* create stack
```
docker-cloud stack crate --name gitlab-backup -f stackfile.yml
```