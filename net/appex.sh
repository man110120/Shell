#!/bin/bash
#特征: 0.   Only for Linux.
#         -----
#         *.从根本原因上解决断流问题.(加速模块开启后验证状态造成的,掌声在哪里?)
#         *.断流的根本原因是没有完全破解验证机制,延迟启动是一个解决办法.现在已经完全解决了这个问题.
#         *.锐速启动脚本不规范,修正 Debian/Ubuntu 不能正常自启动.
#         -----
#         1.支持自动检测公网网卡,多个网卡也能区分.(非正常网卡名字会提示自行输入)
#         2.支持自动匹配内核(也可强制安装指定内核版本的锐速,需锐速支持).
#         3.添加询问是否开启accppp功能.(实测并开启后没有效果.)
#         4.默认设置为G口宽带.(听说设置大点可以提高速度)
#         5.支持一键完全卸载(此脚本安装的无残留).
#         6.所需文件均来自GiuHub,不放心可自行查阅.(完全公开,可查看每次更改记录,适合新手学习)
#         7.不支持自动更换内核,请自行更换.(网上教程非常多)
#         8.不支持 OpenVZ,不需要尝试,会告诉你找不到网卡.
#         9.吐槽: CentOS 居然连 which 都要自己安装,心好累.脚本将就着看吧.从解决断流原因看打开accppp参数还是有点作用的.
#         -----
#         ##.除此脚本外,所有内容均来自互联网.本人不负任何法律责任,仅供学习使用.
#         #1.安装文件appex.zip 为 lotServer的, 增加了一些 lotServer 加速模块。(感谢 @lotServer 提供安装文件.)
#         #2.使用前请日常 update; 欢迎反馈bug.
#         #3.关于配置,请查看附件,根据手册调教,效果更好.
#         #4.确认锐速支持的情况下,如果不能成功安装,请贴出 error log , uname -a 以及 ifconfig 方便我为您适配脚本.(别忘了给IPv4,IPv6打码)
function Welcome()
{
clear
echo -n "                      Local Time :   " && date "+%F [%T]       ";
echo "            ======================================================";
echo "            |                    serverSpeeder                   |";
echo "            |                                         for Linux  |";
echo "            |----------------------------------------------------|";
echo "            |                                       -- By .Vicer |";
echo "            ======================================================";
echo "";
rootness;
cd /root
}

function rootness()
{
if [[ $EUID -ne 0 ]]; then
   echo "Error:This script must be run as root!" 1>&2
   exit 1
fi
}

function pause()
{
read -n 1 -p "Press Enter to Continue..." INP
if [ "$INP" != '' ] ; then
echo -ne '\b \n'
echo "";
fi
}

function Check()
{
echo 'Preparatory work...'
apt-get >/dev/null 2>&1
[ $? -le '1' ] && apt-get -y -qq install curl grep unzip ethtool >/dev/null 2>&1
yum >/dev/null 2>&1
[ $? -le '1' ] && yum -y -q install which sed curl grep awk unzip ethtool >/dev/null 2>&1
[ -f /etc/redhat-release ] && KNA=$(awk '{print $1}' /etc/redhat-release)
[ -f /etc/os-release ] && KNA=$(awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release)
[ -f /etc/lsb-release ] && KNA=$(awk -F'[="]+' '/DISTRIB_ID/{print $2}' /etc/lsb-release)
KNB=$(getconf LONG_BIT)
ifconfig >/dev/null 2>&1
[ $? -gt '1' ] && echo -ne "I can not run 'ifconfig' successfully! \nPlease check your system, and try again! \n\n" && exit 1;
Eth=$(ifconfig |grep -B1 "$(wget -qO- ipv4.icanhazip.com)" |awk -F '[: ]' '/eth/{ print $1 }')
[ -n "$Eth" ] && NumEth=$(ifconfig |awk -F '[: ]' '/eth/{ print $1 }' |sed -n '$=')
[ -z "$Eth" ] && echo -ne "It is seem that you server not as usually. \nPlease input your public Ethernet: " && read tmpEth;
tmpEth=$(echo "$tmpEth"|sed 's/[ \t]*//g') && [ -n "$tmpEth" ] && [ -z $(echo "$tmpEth" |grep -E -i "venet") ] && [[ -n $(ifconfig |grep -E "$tmpEth") ]] && Eth="$tmpEth";
[ -z "$Eth" ] && echo "I can not find the server pubilc Ethernet! " && exit 1
URLKernel='https://raw.githubusercontent.com/0oVicero0/serverSpeeder_kernel/master/serverSpeeder.txt'
MyKernel=$(curl -k -q --progress-bar "$URLKernel" |grep "$KNA/" |grep "/x$KNB/" |grep "/$KNK/" |sort -k3 -t '_' |tail -n 1)
[ -z "$MyKernel" ] && echo -ne "Kernel not be matched! \nYou should change kernel manually, and try again! \n\nView the link to get detaits: \n"$URLKernel" \n\n\n" && exit 1
pause;
}

function SelectKernel()
{
KNN=$(echo $MyKernel |awk -F '/' '{ print $2 }') && [ -z "$KNN" ] && Unstall && echo "Error,Not Matched! " && exit 1
KNV=$(echo $MyKernel |awk -F '/' '{ print $5 }') && [ -z "$KNV" ] && Unstall && echo "Error,Not Matched! " && exit 1
wget --no-check-certificate -q -O "/root/appex/apxfiles/bin/acce-"$KNV"-["$KNA"_"$KNN"_"$KNK"]" "https://raw.githubusercontent.com/0oVicero0/serverSpeeder_kernel/master/$MyKernel"
[ ! -f "/root/appex/apxfiles/bin/acce-"$KNV"-["$KNA"_"$KNN"_"$KNK"]" ] && Unstall && echo "Download Error,Not Found acce-$KNV-[$KNA_$KNN_$KNK]! " && exit 1
}

function Install()
{
Welcome;
Check;
ServerSpeeder;
dl-Lic;
bash /root/appex/install.sh
rm -rf /root/appex* >/dev/null 2>&1
clear
bash /appex/bin/lotServer.sh status
exit 0
}

function Unstall()
{
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/init.d/lotServer >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc2.d/*lotServer >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc3.d/*lotServer >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc4.d/*lotServer >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc5.d/*lotServer >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc0.d/*lotServer >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc1.d/*lotServer >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc6.d/*lotServer >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/init.d/lotServer >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc2.d/*lotServer >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc3.d/*lotServer >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc4.d/*lotServer >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc5.d/*lotServer >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc0.d/*lotServer >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc1.d/*lotServer >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc6.d/*lotServer >/dev/null 2>&1
rm -rf /etc/lotServer.conf >/dev/null 2>&1
chattr -R -i /appex >/dev/null 2>&1
bash /appex/bin/lotServer.sh uninstall -f >/dev/null 2>&1
rm -rf /appex >/dev/null 2>&1
rm -rf /root/appex* >/dev/null 2>&1
echo -ne 'lotServer have been removed! \n\n\n'
exit 0
}

function dl-Lic()
{
chattr -R -i /appex >/dev/null 2>&1
rm -rf /appex >/dev/null 2>&1
mkdir -p /appex/etc
mkdir -p /appex/bin
[ -n "$NumEth" ] && [ "$NumEth" -ne '1' ] && Eth='eth0'
MAC=$(ifconfig "$Eth" |awk '/HWaddr/{ print $5 }')
[ -z "$MAC" ] && MAC=$(ifconfig "$Eth" |awk '/ether/{ print $2 }')
[ -z "$MAC" ] && Unstall && echo "Not Found MAC address! " && exit 1
wget --no-check-certificate -q -O "/appex/etc/apx.lic" "http://serverspeeder.azurewebsites.net/lic?mac=$MAC"
[ "$(du -b /appex/etc/apx.lic |awk '{ print $1 }')" -ne '152' ] && Unstall && echo "Error! I can not generate the Lic for you, Please try again later! " && exit 1
echo "Lic generate success! "
chattr +i /appex/etc/apx.lic
[ -n $(which ethtool) ] && rm -rf /appex/bin/ethtool && cp -f $(which ethtool) /appex/bin
}

function ServerSpeeder()
{
[ ! -f /root/appex.zip ] && wget --no-check-certificate -q -O "/root/appex.zip" "https://raw.githubusercontent.com/0oVicero0/serverSpeeser_Install/master/appex.zip"
[ ! -f /root/appex.zip ] && Unstall && echo "Error,Not Found appex.zip! " && exit 1
mkdir -p /root/appex
unzip -o -d /root/appex /root/appex.zip
SelectKernel;
APXEXE=$(ls -1 /root/appex/apxfiles/bin |grep 'acce-')
sed -i "s/^accif\=.*/accif\=\"$Eth\"/" /root/appex/apxfiles/etc/config
sed -i "s/^apxexe\=.*/apxexe\=\"\/appex\/bin\/$APXEXE\"/" /root/appex/apxfiles/etc/config
}

[ $# == '1' ] && [ "$1" == 'install' ] && KNK="$(uname -r)" && Install;
[ $# == '1' ] && [ "$1" == 'unstall' ] && Welcome && pause && Unstall;
[ $# == '2' ] && [ "$1" == 'install' ] && KNK="$2" && Install;
echo -ne "Usage:\n     bash $0 [install |unstall |install '{lotServer of Kernel Version}']\n"
