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

rm -rf $DIR2/test.sql
echo "show tables;" >> $DIR2/test.sql

rm -rf $DIR2/table.txt
/data/dbserver/mysql/bin/mysql -uroot -p${mysql_pwd} portal < $DIR2/test.sql >> $DIR2/table.txt

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

#分库备份
cd $DIR
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt portal > $DIR/portal.sql
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt xuexi > $DIR/xuexi.sql
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt conf_init > $DIR/conf_init.sql
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt evaluate > $DIR/evaluate.sql
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt hubei > $DIR/hubei.sql
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt jiangxi > $DIR/jiangxi.sql
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt tianjin > $DIR/tianjin.sql
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt webapp > $DIR/webapp.sql
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt dzsb > $DIR/dzsb.sql
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt sundatapaas > $DIR/sundatapaas.sql
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt sundataoa > $DIR/sundataoa.sql
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt sundata_cloud > $DIR/sundata_cloud.sql
/data/dbserver/mysql/bin/mysqldump -uroot -p${mysql_pwd} --opt school_home > $DIR/school_home.sql

#将portal.sql打包成portal.tar.gz，将其它打包成other.tar.gz。打包完成后，删除所有.sql文件
/bin/tar -czf portal.tar.gz portal.sql
/bin/tar -czf other.tar.gz --exclude=portal.sql *.sql
/bin/rm -f $DIR/*.sql

#删除60天前的备份
/usr/bin/find /data/backallmysql -mtime +60 -name "*.*" -exec rm -rf {} \;
/usr/bin/find /data/backallmysqldbtable -mtime +60 -name "*.*" -exec rm -rf {} \;
