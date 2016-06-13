<?php
// Zabbix GUI configuration file.
global $DB;

$DB['TYPE']     = 'MYSQL';
$DB['SERVER']   = '192.168.1.234';
$DB['PORT']     = '0';
$DB['DATABASE'] = 'zabbix';
$DB['USER']     = 'zabbix';
$DB['PASSWORD'] = 'zabbixpass';

// Schema name. Used for IBM DB2 and PostgreSQL.
$DB['SCHEMA'] = '';

$ZBX_SERVER      = '192.168.1.234';
$ZBX_SERVER_PORT = '10051';
$ZBX_SERVER_NAME = 'zabbix-server';

$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
?>
