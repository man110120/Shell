#!/bin/bash
space_a=$(df -h | sed -n '2p' |awk '{print int($5)}')
space_b=$(df -h | sed -n '4p' | awk '{print int($5)}')
ip=$(ifconfig | grep inet |sed -n '5p' | awk '{print $2}')
if [ ${space_a} -ge "90"  ];then
echo "disk_xvdb1 is error" && /bin/sendEmail -f fajianxiang@163.com -t shoujianren@139.com -s smtp.163.com -u "${ip} disk_xvdb1 over 90" -m "${ip} zy-web disk_xvdb1 is over 90%" -xu username -xp email_passwd
elif [ ${space_b} -ge "90" ];then
echo "disk_xvdb2 is error" && /bin/sendEmail -f fajianxiang@163.com -t shoujianren@139.com -s smtp.163.com -u "${ip} disk_xvdb1 over 90" -m "${ip} zy-web disk_xvdb2 is over 90%" -xu username -xp email_passwd
fi
