#!/bin/bash
ps -ef|grep \[h]xRegister.jar
if [ "$?" = "0" ];then
exit
else
nohup java -jar /data/qdrop/hxRegister/hxRegister.jar > log.txt 2>&1 &
fi
