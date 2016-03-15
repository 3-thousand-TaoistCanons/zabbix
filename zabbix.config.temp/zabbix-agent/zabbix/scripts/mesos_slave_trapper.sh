#!/usr/bin/env bash
# grab , print and send mesos monitoring values to zabbix via zabbix_sender
# Author Email:  jyliu@dataman-inc.com
# Date: 2015-08-19


MESOS_SLAVE_ADDR=`netstat -lntp|grep mesos-slave|awk '{print $4}'`
TMPFILE=`mktemp --suffix=-mesosslave-monitoring`

ZABBIX_CONF=/etc/zabbix/zabbix_agentd.conf

PRE="mesos-"

trap "rm -f $TMPFILE ; exit" SIGHUP SIGINT SIGTERM  EXIT

curl http://$MESOS_SLAVE_ADDR/metrics/snapshot 2>/dev/null|python -m json.tool 1>$TMPFILE

sed -i -e 's@/@-@g' -e 's/["{}:,]//g' -e '/^[[:space:]]*$/d'  -e 's/^[[:space:]]*/'`hostname`' mesos-/g'  $TMPFILE


/usr/bin/zabbix_sender -c $ZABBIX_CONF -i $TMPFILE
