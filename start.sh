#!/bin/bash

rsyslogd

printenv | sed 's/^\(.*\)\=\(.*\)$/export \1\="\2"/g'  > /root/project_env.sh
chmod 777 /root/project_env.sh

cron -L15 -f