#!/bin/bash
. ../config.cfg

mysql -u$ZBX_MYSQL_USER -p$ZBX_MYSQL_PASS -h$ZBX_MYSQL_IP $ZBX_MYSQL_DATABASE < zabbix_init.sql
mysql -u$ZBX_MYSQL_USER -p$ZBX_MYSQL_PASS -h$ZBX_MYSQL_IP $ZBX_MYSQL_DATABASE < zabbix_init.sql
#mysqldump -u$ZBX_MYSQL_USER -p$ZBX_MYSQL_PASS -h$ZBX_MYSQL_IP $ZBX_MYSQL_DATABASE > zabbix_init.sql
