#!/bin/sh
#线上环境难免遇到一些程序bug，一类bug可能是程序没有关闭mysql连接导致mysql processlist里面大量的sleep线程不释放的情况，遇到这样的情况，只能kill 掉这些sleep的连接，等程序修复bug
user=
passwd=
host=

while : 
do
  n=`mysqladmin processlist -u$user -p$passwd -h$host | grep -i sleep | wc -l`
  date=`date +%Y%m%d[%H:%M:%S]`
  echo $n

  if [ "$n" -gt 50 ]
  then
  for i in `mysqladmin processlist -u$user -p$passwd -h$host | grep -i sleep | awk '{print $2}'`
  do
     mysqladmin -u$user -p$passwd -h$host kill $i
  done
  echo "sleep is too many I killed it " >> /tmp/sleep.log
  echo "$date : $n" >> /tmp/sleep.log
  fi               
  sleep 1
done
