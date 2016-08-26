1、批量创建
#!/bin/bash 
USER="root" 
PASS="123456" 
 
#The datebase name will be created 
for i in jxqahlxx jxqcbxx jxqdf1x jxqdf2x jxqdf3x jxqdf4x jxqds1x jxqds2x jxqds3x jxqdsxx jxqfhlxx jxqhblxx jxqjhlsyxx jxqjhlxx jxqnclxx jxqnhsyxx jxqpzxx jxqqdlxx jxqsyxx jxqtjlxx jxqtxxx jxqwxxx jxqxylsyxx jxqzjlxx jxqzslxx jxqzxxx jxqzzxlxx
do 
/data/dbserver/mysql/bin/mysql -u $USER -p$PASS << EOF >/dev/null 
 
CREATE DATABASE $i default character set utf8 collate utf8_general_ci
 
EOF
echo 'create' $i
done


2、批量导入
#!/bin/bash  
#The username of mysql database  
USER="root"  
  
#The password of mysql database  
PASS="123456" 
  
#The datebase name will be created  
for i in jxqyyxx jxqahlxx jxqcbxx jxqdf1x jxqdf2x jxqdf3x jxqdf4x jxqds1x jxqds2x jxqds3x jxqdsxx jxqfhlxx jxqhblxx jxqjhlsyxx jxqjhlxx jxqnclxx jxqnhsyxx jxqpzxx jxqqdlxx jxqsyxx jxqtjlxx jxqtxxx jxqwxxx jxqxylsyxx jxqzjlxx jxqzslxx jxqzxxx jxqzzxlxx
do  
/data/dbserver/mysql/bin/mysql -u $USER -p$PASS << EOF >/dev/null 
use $i  
source /root/sql/$i.sql  
EOF

echo 'source' $i
done
