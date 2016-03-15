#!/bin/bash

TMPFILE=$1
ZABBIX_CONF=/etc/zabbix/zabbix_agentd.conf

if [ -z "$TMPFILE" ];then
	echo "Usage: ./$0 sendfile"
	exit 1
fi


cat $TMPFILE  | while read line
do
echo $line
echo "$line" |/usr/bin/zabbix_sender -vv -c $ZABBIX_CONF -s `hostname` -i - |grep --color=auto "failed\: 1"
done
