<?php
// Zabbix GUI configuration file.
global $DB;

$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = '--ZBX_MYSQL_IP--';
$DB['PORT']     = '0';
$DB['DATABASE'] = '--ZBX_MYSQL_DATABASE--';
$DB['USER']     = '--ZBX_MYSQL_USER--';
$DB['PASSWORD'] = '--ZBX_MYSQL_PASS--';

// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = '--ZBX_SERVER_IP--';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = 'zabbix-server';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
?>
