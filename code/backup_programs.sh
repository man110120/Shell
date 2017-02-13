#!/bin/bash
DATENOW=$(date +%Y-%m-%d-%H-%M-%S)
DIR_school_zhanqun=/data/Programs_school/$DATENOW
DIR_portal_v2=/data/Programs_portal_v2/$DATENOW
DIR_portal_v2_jigou=/data/Programs_portal_v2_jigou/$DATENOW
DIR_szyt=/data/Programs_szyt/$DATENOW
DIR_portal_v3_space=/data/Programs_portal_v3_space/$DATENOW
DIR_portal_v3_ziyuan=/data/Programs_portal_v3_ziyuan/$DATENOW
#backup school station group
if [ ! -d $DIR_school_zhanqun ];then
    mkdir $DIR_school_zhanqun
fi
cd /data/www
#exclude  uploadfile
tar -zcvf $DIR_school_zhanqun/Programs_school_$DATENOW.tar.gz --exclude=uploadfile edudhfx edugjzx eduhtxx edujgyey edulqxx edulyxx edumsxx edumsyey edusyyey edutdxx edutdzx edutxxx eduwgyxx eduygxx eduygzx wgyxy ytjy ytjyj ytyey zsjnxy

#backup portal_v2
if [ ! -d $DIR_portal_v2 ];then
    mkdir $DIR_portal_v2
fi
cd /data/www/
tar -zcvf $DIR_portal_v2/Programs_portal_v2_$DATENOW.tar.gz --exclude=uploads --exclude=uploads.default --exclude=uploads.default1 portal_v2

#backup portal_v2_jigou
if [ ! -d $DIR_portal_v2_jigou ];then
    mkdir $DIR_portal_v2_jigou
fi
cd /data/www
tar -zcvf $DIR_portal_v2_jigou/Programs_portal_v2_jigou_$DATENOW.tar.gz --exclude=Runtime portal_v2_jigou

#backup szyt
if [ ! -d $DIR_szyt ];then
    mkdir $DIR_szyt
fi
cd /data/www
tar -zcvf $DIR_szyt/Programs_szyt_$DATENOW.tar.gz --exclude=Runtime --exclude=uploads szyt

#backup portal_v3_space
if [ ! -d $DIR_portal_v3_space ];then
    mkdir $DIR_portal_v3_space
fi
cd /data/www/v3
tar -zcvf $DIR_portal_v3_space/Programs_portal_v3_space_$DATENOW.tar.gz --exclude=Runtime --exclude=uploads portal_v3_space

#backup portal_v3_ziyuan
if [ ! -d $DIR_portal_v3_ziyuan ];then
    mkdir $DIR_portal_v3_ziyuan
fi
cd /data/www/v3
tar -zcvf $DIR_portal_v3_ziyuan/Programs_portal_v3_ziyuan_$DATENOW.tar.gz --exclude=Runtime --exclude=uploads portal_v3_ziyuan

#Deleted more than 30 days
rm -rf $(find /data/Programs_school -mtime +30 -name "*" -type d)
rm -rf $(find /data/Programs_portal_v2 -mtime +30 -name "*" -type d)
#find /data/Programs_school -mtime +30 -name "*.*" -exec rm -rf {} \;
#find /data/Programs_portal_v2 -mtime +30 -name "*.*" -exec rm -rf {} \;
#find /data/Programs_portal_v2_jigou -mtime +30 -name "*.*" -exec rm -rf {} \;
#find /data/Programs_szyt -mtime +30 -name "*.*" -exec rm -rf {} \;
#find /data/Programs_portal_v3_space -mtime +30 -name "*.*" -exec rm -rf {} \;
find /data/Programs_portal_v3_ziyuan -mtime +30 -name "*.*" -exec rm -rf {} \;
