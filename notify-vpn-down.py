#!/bin/python3

import datetime
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
# from email.MIMEMultipart import MIMEMultipart
#from email.MIMEText import MIMEText

msg = MIMEMultipart()
msg['From'] = 'jvillegas@sonic.net'
msg['To'] = 'jvillegas@sonic.net'
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
mailserver.login('jvillegas@sonic.net', '4Mexico420$!')

mailserver.sendmail('jvillegas@sonic.net','jvillegas@sonic.net',msg.as_string())

mailserver.quit()
