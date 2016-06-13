#!/bin/bash

to=$1
subject=$2
body=$3
body=`echo $body|tr '\r' '\n'`



curl http://--SENDMAIL_IP--:--SENDMAIL_PORT--/sendmail/ --data "key=--SENDMAIL_KEY--&mailto=$to&sub=$subject&content=$body"
