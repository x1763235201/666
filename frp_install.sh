#!/bin/bash
############开始安装
echo -e "\033[35m 程序载入中，请稍后... \033[0m"
echo "
==================================================================
                                                                           
                     ☆-Frp一键安装脚本
                     ☆-https://yaohuo.me  
			   
=================================================================="
echo " 本脚本适用于Centos7.X系列，其他版本请勿尝试！！！"
read -p " 请输入Frp Token：" passwd


##清理环境
echo -e "\033[35m 程序安装中，请稍等... \033[0m"
systemctl stop frps >/dev/null 2>&1
systemctl disable frps >/dev/null 2>&1
rm -rf /home/frp >/dev/null 2>&1
rm -rf /lib/systemd/system/frps.service >/dev/null 2>&1
firewall-cmd --zone=public --remove-port=7000/tcp --permanent >/dev/null 2>&1
firewall-cmd --zone=public --remove-port=2021/tcp --permanent >/dev/null 2>&1
firewall-cmd --zone=public --remove-port=444/tcp --permanent >/dev/null 2>&1
firewall-cmd --zone=public --remove-port=7500/tcp --permanent >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
sleep 1
cd /home
###获取IP地址
ipAddress=`curl -s http://members.3322.org/dyndns/getip`;
wget http://63.223.84.40/frp/frp.tar.gz >/dev/null 2>&1
tar -zxvf frp.tar.gz >/dev/null 2>&1
echo "[common]
bind_port = 7000
bind_addr = 0.0.0.0
#http端口
vhost_http_port = 80
#https端口
vhost_https_port = 443
token = $passwd
tcp_mux = true
#管理后台使用的端口及用户信息(后台可查看各端口使用信息，配置可选)
dashboard_port = 7500
dashboard_user = x176
dashboard_pwd = $passwd">/home/frp/frps.ini

##开放防火墙
sleep 1
firewall-cmd --zone=public --add-port=7000/tcp --permanent >/dev/null 2>&1
firewall-cmd --zone=public --add-port=2021/tcp --permanent >/dev/null 2>&1
firewall-cmd --zone=public --add-port=444/tcp --permanent >/dev/null 2>&1
firewall-cmd --zone=public --add-port=7500/tcp --permanent >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
sleep 1
echo "[Unit]
Description=frps service
After=network.target syslog.target
Wants=network.target

[Service]
Type=simple
ExecStart=/home/frp/frps -c /home/frp/frps.ini

[Install]
WantedBy=multi-user.target">/lib/systemd/system/frps.service
sleep 1
systemctl enable frps >/dev/null 2>&1
systemctl start frps
rm -rf frp.tar.gz >/dev/null 2>&1
sleep 1
clear
echo "恭喜哦小伙伴，Frp安装完成了！"
echo "
#############################################################
   服务器IP：$ipAddress
   http端口：2021
   https端口：444
   frp token: $passwd
   frp面板地址：$ipAddress:7500
   frp面板用户名：yaohuo
   frp面板密码：$passwd
   启动frp服务端 
   systemctl start frps 
   打开自启动
   systemctl enable frps
   重启frp服务端 
   systemctl restart frps
   停止应用
   systemctl stop frps
   查看应用的日志
   systemctl status frps
   停止开机自启动
   systemctl disable frps
   域名模式为自定义域名
#############################################################
"