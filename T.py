#! /usr/bin/python
# -*- encoding:utf-8 -*-

import smtplib
from email.mime.text import MIMEText
username = "security@chinalife.cn"
password = "***"
_to = "114.247.91.201"
_toPriv = "36.112.11.10"

# email
msg = MIMEText("")
msg["Subject"] = "test"
msg["From"] = username
msg["To"] = _to

s = smtplib.SMTP("smtp.chinalife.cn", timeout=30)  # 连接smtp邮件服务器,端口默认是25
s.login(username, password)  # 登陆服务器
s.sendmail(username, _to, msg.as_string())  # 发送邮件
s.close()