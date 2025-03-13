#!/bin/python3

import datetime
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

msg = MIMEMultipart()
msg['From'] = 'SONIC_EMAIL_ADDRESS'
msg['To'] = 'SONIC_EMAIL_ADDRESS'
msg['Subject'] = 'VPN Down '+datetime.datetime.now().strftime('%m/%d %H:%M')
message = 'VPN is DOWN'
msg.attach(MIMEText(message))

mailserver = smtplib.SMTP('mail.sonic.net',587)
# identify ourselves to smtp gmail client
mailserver.ehlo()
# secure our email with tls encryption
mailserver.starttls()
# re-identify ourselves as an encrypted connection
mailserver.ehlo()
mailserver.login('SONIC_EMAIL_ADDRESS', 'SONIC_EMAIL_PASSWORD')

mailserver.sendmail('SONIC_EMAIL_ADDRESS','SONIC_EMAIL_ADDRESS',msg.as_string())

mailserver.quit()
