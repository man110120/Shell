#!/bin/sh

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
