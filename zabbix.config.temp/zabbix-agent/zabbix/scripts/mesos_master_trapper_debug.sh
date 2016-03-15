#!/usr/bin/env bash
# grab , print and send mesos monitoring values to zabbix via zabbix_sender
# Author Email:  jyliu@dataman-inc.com
# Date: 2015-08-19


MASTER_ADDR=$1

TMPFILE=`mktemp --suffix=-mesos-monitoring`
TMPFILE2=`mktemp --suffix=-mesos-monitoring`

ZABBIX_CONF=/etc/zabbix/zabbix_agentd.conf

PRE="mesos-"

if [ -z $MASTER_ADDR ];then
	echo "Usage: $0 master_addr" && exit 1
fi


trap "rm -f $TMPFILE $TMPFILE2; exit" SIGHUP SIGINT SIGTERM  EXIT

curl http://$MASTER_ADDR/metrics/snapshot 2>/dev/null|python -m json.tool 1>$TMPFILE

sed -i -e 's@/@-@g' -e 's/["{}:,]//g' -e '/^[[:space:]]*$/d'  -e 's/^[[:space:]]*/'`hostname`' mesos-/g'  $TMPFILE
awk '{print $1" "$2"['$MASTER_ADDR'] "$3}' $TMPFILE > $TMPFILE2

cat $TMPFILE2  | while read line
do
echo $line
echo $line |/usr/bin/zabbix_sender -vv -c $ZABBIX_CONF -i - 
done
