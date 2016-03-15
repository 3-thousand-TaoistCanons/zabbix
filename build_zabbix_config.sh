#!/bin/bash

set -eu

. ./config.cfg

rm -rf zabbix
cp -fR zabbix.config.temp zabbix

grep -rl '' zabbix/* | xargs sed -i 's/\-\-CONFIGSERVER_IP\-\-/'$CONFIGSERVER_IP'/g'
grep -rl '' zabbix/* | xargs sed -i 's/\-\-CONFIGSERVER_PORT\-\-/'$CONFIGSERVER_PORT'/g'
grep -rl '' zabbix/* | xargs sed -i 's/\-\-ZBX_MYSQL_IP\-\-/'$ZBX_MYSQL_IP'/g'
grep -rl '' zabbix/* | xargs sed -i 's/\-\-ZBX_MYSQL_DATABASE\-\-/'$ZBX_MYSQL_DATABASE'/g'
grep -rl '' zabbix/* | xargs sed -i 's/\-\-ZBX_MYSQL_USER\-\-/'$ZBX_MYSQL_USER'/g'
grep -rl '' zabbix/* | xargs sed -i 's/\-\-ZBX_MYSQL_PASS\-\-/'$ZBX_MYSQL_PASS'/g'
grep -rl '' zabbix/* | xargs sed -i 's/\-\-ZBX_MYSQL_CHECK_USER\-\-/'$ZBX_MYSQL_CHECK_USER'/g'
grep -rl '' zabbix/* | xargs sed -i 's/\-\-ZBX_MYSQL_CHECK_PASS\-\-/'$ZBX_MYSQL_CHECK_PASS'/g'
grep -rl '' zabbix/* | xargs sed -i 's/\-\-ZBX_SERVER_IP\-\-/'$ZBX_SERVER_IP'/g'
grep -rl '' zabbix/* | xargs sed -i 's/\-\-SENDMAIL_IP\-\-/'$SENDMAIL_IP'/g'
grep -rl '' zabbix/* | xargs sed -i 's/\-\-SENDMAIL_PORT\-\-/'$MAIL_PORT'/g'
grep -rl '' zabbix/* | xargs sed -i 's/\-\-SENDMAIL_KEY\-\-/'$MAIL_ORIGIN_KEY'/g'

sed -i 's/Server=127.0.0.1/Server='$ZBX_SERVER_IP'/g' zabbix/zabbix-agent/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive='$ZBX_SERVER_IP'/g' zabbix/zabbix-agent/zabbix/zabbix_agentd.conf

cd zabbix/zabbix-agent
tar czf zabbix_config.tar.gz logrotate.d zabbix
rm -rf logrotate.d zabbix
cd ../../

rm -rf config/zabbix
mv zabbix config/
