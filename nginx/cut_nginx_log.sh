#!/bin/bash
# This script run at 00:00,每天0点开始切割日志
#添加定时执行任务 0 0 * * * /bin/bash  /data/webserver/nginx/sbin/cut_nginx_log.sh

# The Nginx logs path
logs_path="/data/webserver/nginx/logs/"
mkdir -p ${logs_path}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")/
mv ${logs_path}access.log ${logs_path}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")/access_$(date -d "yesterday" +"%Y%m%d").log
/data/webserver/nginx/sbin/nginx -s reload
