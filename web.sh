#!/bin/bash -x

#
# chinalife/WEB
#
# Installs a PPTP WEB-only system for CentOS
#
# @package WEB 2.0
# @since WEB 1.0
# @author Drew Morris
#

(

WEB_IP=`curl ipv4.icanhazip.com>/dev/null 2>&1`

WEB_USER=""
WEB_PASS=""

WEB_LOCAL="36.112.11.9"
WEB_REMOTE="114.247.91.200"

yum -y groupinstall "Development Tools"
rpm -Uvh http://poptop.sourceforge.net/yum/stable/rhel6/pptp-release-current.noarch.rpm
yum -y install policycoreutils policycoreutils
yum -y install ppp pptpd
yum -y update

echo "1" > /proc/sys/net/ipv4/ip_forward
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf

sysctl -p /etc/sysctl.conf

echo "localip $WEB_LOCAL" >> /etc/pptpd.conf # Local IP address of your WEB server
echo "remoteip $WEB_REMOTE" >> /etc/pptpd.conf # Scope for your home network

echo "ms-dns 8.8.8.8" >> /etc/ppp/options.pptpd # Google DNS Primary
echo "ms-dns 209.244.0.3" >> /etc/ppp/options.pptpd # Level3 Primary
echo "ms-dns 208.67.222.222" >> /etc/ppp/options.pptpd # OpenDNS Primary

echo "$WEB_USER pptpd $WEB_PASS *" >> /etc/ppp/chap-secrets

service iptables start
echo "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> /etc/rc.local
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
service iptables save
service iptables restart

service pptpd restart
chkconfig pptpd on

echo -e '\E[37;44m'"\033[1m Installation Log: /var/log/WEB-installer.log \033[0m"
echo -e '\E[37;44m'"\033[1m You can now connect to your WEB via your external IP ($WEB_IP)\033[0m"

echo -e '\E[37;44m'"\033[1m Username: $WEB_USER\033[0m"
echo -e '\E[37;44m'"\033[1m Password: $WEB_PASS\033[0m"

) 2>&1 | tee /var/log/WEB-installer.log