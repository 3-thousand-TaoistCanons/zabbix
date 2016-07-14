#!/bin/bash
. ../config.cfg

day=`date  +%m-%d`
tables=$(mysql -N -u$ZBX_MYSQL_USER -p$ZBX_MYSQL_PASS -h$ZBX_MYSQL_IP $ZBX_MYSQL_DATABASE -e "show tables;" 2>/dev/null | grep -vE "alerts|auditlog|history|trends")
mysqldump -u$ZBX_MYSQL_USER -p$ZBX_MYSQL_PASS -h$ZBX_MYSQL_IP $ZBX_MYSQL_DATABASE ${tables} >zabbixdb.conf.sql
mysqldump -u$ZBX_MYSQL_USER -p$ZBX_MYSQL_PASS -h$ZBX_MYSQL_IP -d $ZBX_MYSQL_DATABASE  >zabbixdb.nodata.sql
