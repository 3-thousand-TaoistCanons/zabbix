#!/bin/bash
. ../config.cfg

sql="
GRANT SELECT,SHOW VIEW,SUPER,Replication client,replication slave ON *.* TO '"$ZBX_MYSQL_CHECK_USER"'@'%' identified by '"$ZBX_MYSQL_CHECK_PASSWORD"';FLUSH PRIVILEGES ;
GRANT ALL ON $ZBX_MYSQL_DATABASE.* TO '"$ZBX_MYSQL_USER"'@'%' identified by '"$ZBX_MYSQL_PASS"';FLUSH PRIVILEGES ;

"
mysql -uroot -p$ZBX_MYSQL_ROOT_PASS -h$ZBX_MYSQL_IP -e "$sql"
