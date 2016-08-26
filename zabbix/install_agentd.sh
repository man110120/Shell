#!/bin/bash
#zabbix server 端IP 地址
SERVER="192.168.1.31"
#zabbix 版本号，也就是源码包.tar.gz前面的部分
VER="zabbix-3.0.2"
useradd zabbix
yum -y groupinstall "Development tools"
wget -c http://192.168.1.31:88/$VER.tar.gz #需要改为你自己的下载地址
tar xvf $VER.tar.gz
cd $VER
./configure --prefix=/usr/local/zabbix --enable-agent
make && make install
#该版本zabbix不需要make，直接make install,也可以make一下也没什么问题，其它版本请酌情修改。
echo "Installation completed !"
mkdir /var/log/zabbix
chown zabbix.zabbix /var/log/zabbix
cp misc/init.d/fedora/core/zabbix_agentd /etc/init.d/
chmod 755 /etc/init.d/zabbix_agentd
sed -i "s#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix#g" /etc/init.d/zabbix_agentd
 
ln -s /usr/local/zabbix/etc /etc/zabbix
ln -s /usr/loca/zabbix/bin/zabbix_get /usr/bin/
ln -s /usr/loca/zabbix/bin/zabbix_sender /usr/bin/
ln -s /usr/loca/zabbix/sbin/zabbix_agent /usr/sbin/
ln -s /usr/loca/zabbix/sbin/zabbix_agentd /usr/sbin/
 
echo "zabbix-agent 10050/tcp #Zabbix Agent" >> /etc/services
echo "zabbix-agent 10050/udp #Zabbix Agent" >> /etc/services
echo "zabbix-trapper 10051/tcp #Zabbix Trapper" >> /etc/services
echo "zabbix-trapper 10051/udp #Zabbix Trapper" >> /etc/services
 
sed -i "s/Server\=127.0.0.1/Server=$SERVER/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive\=127.0.0.1/ServerActive=$SERVER:20051/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s#tmp/zabbix_agedtd.log#var/log/zabbix/zabbix_agentd.log#g" /etc/zabbix/zabbix_agentd.conf
sed -i "s#UnsafeUserParameters=0#UnsafeUserParameters=1#g" /etc/zabbix/zabbix_agentd.conf
sed -i "s%# Include=/usr/local/etc/zabbix_agentd.userparams.conf%Include=/etc/zabbix/zabbix_agentd.conf.d/%g" /etc/zabbix/zabbix_agentd.conf
 
chkconfig zabbix_agentd on
service zabbix_agentd start

搭配saltstack的sls
[root@localhost zabbix]# cat install_zabbix_agentd.sls 
zabbix.file:
  file.managed:
    - name: /usr/local/src/zabbix-3.0.2.tar.gz
    - source: salt://zabbix/zabbix-3.0.2.tar.gz
    - user: root
    - mode: 755
/usr/local/src/zabbix_agentd.sh:
  cmd.script:
  - source: salt://zabbix/zabbix_agentd.sh
  - user: root
  - env:
    - BATCH: 'yes'
  - require:
    - file: zabbix.file
  - unless: test -d /usr/local/zabbix

