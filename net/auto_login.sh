#!/bin/bash
#可供一般PT站自动登陆，未公开带自动识别验证码的shell。
#填写邮箱后可以接受登陆失败的信息和未读消息(收件箱和系统，并标记为已读)。
#默认邮箱程序为 mailx，请自行配置，否则不要填写邮箱。
#Debian 7 下测试成功(200+次)，如有bug，不负责解决。如果对您造成损失，我不负责任何责任。
#如果你不知道我在说啥，那就证明此shell没有用任何用处，我只是在体验curl的强大。
#以MT为例，将代码中的中文全部替换为自己的信息。
# 可使用 bash -x shell.sh 进行调试。
# 坑已填平，不再公开更新，支持MT,CHD,HDTime等等。。。
# MT 需要设置 Decrypt='0'， CHD,HDTime 需要设置 Decrypt='1' ，其他站自测。

# User Data, You should modify it.
export TheHost='https://tp.m-team.cc'
export Account='username=用户名&password=密码'
export MyeMail='邮箱'
export Decrypt='0'

# Do not modify the following.
export HostUrl="$(echo "${TheHost}" |awk -F '://|/' '{print $2}')"
export dirCookie='/tmp/cookie.txt'

Request(){
URL="${1}"
DATA="${2:-}"
ItRef="${3:-login.php}"
[[ -z "$(echo "${URL}" |grep '://')" ]] && echo "Error! URL incorrect. " && exit 1
[ -n "${Decrypt}" ] && [ "${Decrypt}" -eq '1' ] && [ "${ItRef}" != 'login.php' ] && {
curl -k --silent \
-H 'Host: '${HostUrl}'' \
-H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0' \
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
-H 'Accept-Language: zh-CN,en-US;q=0.8,zh;q=0.5,en;q=0.3' \
-H 'Accept-Encoding: gzip, deflate' \
-H 'Referer: '${TheHost}'/'${ItRef}'' \
-H 'Connection: keep-alive' \
-b ''${dirCookie}'' \
-c ''${dirCookie}'' \
${DATA} ''${URL}'' |gzip -dc 
} || {
curl -k --silent \
-H 'Host: '${HostUrl}'' \
-H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:45.0) Gecko/20100101 Firefox/45.0' \
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
-H 'Accept-Language: zh-CN,en-US;q=0.8,zh;q=0.5,en;q=0.3' \
-H 'Accept-Encoding: gzip, deflate' \
-H 'Referer: '${TheHost}'/'${ItRef}'' \
-H 'Connection: keep-alive' \
-b ''${dirCookie}'' \
-c ''${dirCookie}'' \
${DATA} ''${URL}''
}
}

uMessages(){
export ReceiveBox=''${1:-action=viewmailbox&box=1&unread=yes}''
[[ -z "$(echo "$(Request ''${TheHost}'/usercp.php' '-X GET' 'index.php')" |grep 'messages.php' |grep 'embedded')" ]] && export Unread='0' || export Unread='1'
[ "${Unread}" -eq '1' ] && ReadIt="$(echo "$(Request ''${TheHost}'/messages.php?'${ReceiveBox}'' '-X GET' 'messages.php')" |grep -A1 'unreadpm' |grep 'messages.php?action=viewmessage')"
[ "${Unread}" -eq '1' ] && [ -n "${ReadIt}" ] && [ -n "$(which mailx)" ] && TheMessage="$(echo "$(echo "${ReadIt}" |awk -F '"' '{print $2}')" |head -n 1)" && echo "$(Request ''${TheHost}'/'${TheMessage}'' '-X GET' 'messages.php')" >/dev/null
[ "${Unread}" -eq '1' ] && [ -n "${ReadIt}" ] && [ -n "$(which mailx)" ] && [ -n "${TheMessage}" ] && echo -e "New Message\n\n"$(echo "${ReadIt}" |awk -F '<|>' '{print $5}' |head -n 1)"\n"${TheHost}"/"${TheMessage}"\n" |mailx -s "Notice for ${HostUrl}" "${MyeMail}"
[ "${Unread}" -eq '0' ] || uMessages 'action=viewmailbox&box=-2&unread=yes'
}

Request ''${TheHost}'/takelogin.php' '-X POST -d '${Account}'' >/dev/null
[[ -n "$(echo "$(Request ''${TheHost}'/usercp.php' '-X GET' 'index.php')" |grep 'logout.php')" ]] && Login='1' || Login='0'

[[ "${Login}" -eq '1' ]] && {
echo -e "#${HostUrl}#\nLogin Success! " 
[ -n "${MyeMail}" ] && uMessages;
rm -rf "${dirCookie}";
exit 0
} || {
[ -n "${MyeMail}" ] && [ -n "$(which mailx)" ] && echo -e "$(date "+%F [%T]")\nLogin Fail! " |mailx -s "Notice for ${HostUrl}" "${MyeMail}"
echo -e "#${HostUrl}#\nLogin Fail! " && rm -rf "${dirCookie}";
exit 1
}
