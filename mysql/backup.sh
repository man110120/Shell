#!/bin/bash
DATENOW=$(date +%Y-%m-%d-%H-%M-%S);
DIR=/data/backallmysql/$DATENOW
DIR2=/data/backallmysqldbtable/$DATENOW
mysql_pwd='12356'

if [ -d $DIR ]; then
echo "find ok!"
else
mkdir $DIR
echo "creat ok"
fi


if [ -d $DIR2 ]; then
echo "find2 ok!"
else
mkdir $DIR2
echo "creat2 ok"
fi

cd $DIR2
echo "show tables;" > $DIR2/test.sql
/data/dbserver/mysql/bin/mysql -uroot -p${mysql_pwd} portal < $DIR2/test.sql > $DIR2/table.txt

#分表导出sql
while read Table
do
        if [ "${Table}" = "Tables_in_portal" ];then
                continue
        fi
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt portal ${Table} > $DIR2/${Table}.sql
done < $DIR2/table.txt

#分表压缩导出的.sql文件
/bin/sed -i '1d' table.txt
for i in $(cat table.txt)
do
/bin/tar czf $i.tar.gz $i.sql
done
/bin/rm -rf $DIR2/*.sql

#备份所有数据库(不包含默认数据库)
cd $DIR
/data/dbserver/mysql/bin/mysql -uroot -p${mysql_pwd}  -e "show databases;" -N  >dbName.txt

for i in mysql infomation_schema performance_schema
do
 /bin/sed -i "/$i/d" dbName.txt
done

for i in `cat dbName.txt`
do
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt $i > $DIR/$i.sql
done
#将portal.sql打包成portal.tar.gz，将其它打包成other.tar.gz。打包完成后，删除所有.sql文件
/bin/tar -czf portal.tar.gz portal.sql
/bin/tar -czf other.tar.gz --exclude=portal.sql *.sql
/bin/rm -f $DIR/*.sql

#删除60天前的备份
/usr/bin/find /data/backallmysql -mtime +60 -name "*.*" -exec rm -rf {} \;
/usr/bin/find /data/backallmysqldbtable -mtime +60 -name "*.*" -exec rm -rf {} \;
