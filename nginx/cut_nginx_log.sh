#!/bin/bash
# 每天0点开始切割日志
#添加定时执行任务 0 0 * * * /bin/bash  /data/webserver/nginx/sbin/cut_nginx_log.sh
path="/data/webserver/nginx/logs/"
logs_path=${path}$(date -d last-day +%Y)/$(date -d last-day+%Y%m)
if [ ! -d ${logs_path} ];then
mkdir -p ${logs_path}
fi
mv ${path}access.log ${logs_path}/access_$(date +%Y%m%d).log
/data/webserver/nginx/sbin/nginx -s reload
