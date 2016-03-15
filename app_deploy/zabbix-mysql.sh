#!/bin/bash
. ../config.cfg
token=`./get_token.sh`

curl -X POST $BASE_URL/api/v1/applications/deploy \
        -H Authorization:$token \
        -H Content-Type:application/json -d '{
           "appName": "'${SERVICE_PRE}'-mysql",
           "clusterId": "'$SRY_CLUSTERID'",
           "containerCpuSize": 1,
           "containerPortsInfo": [],
           "containerVolumesInfo": [
            {
                "containerPath": "/var/lib/mysql",
                "hostPath": "/data/lib/mysql"
            }
          ],
           "containerMemSize": 3072,
           "containerNum": "1",
           "envs": [
            {
                "key": "CONFIG_SERVER",
                "value": "http://'$CONFIGSERVER_IP':'$CONFIGSERVER_PORT'"
            },
            {
                "key": "SERVICE",
                "value": "zabbix/zabbix-mysql"
            },
            {
                "key": "NOHOSTNAME",
                "value": "true"
            },
            {
                "key": "MYSQL_ROOT_PASSWORD",
                "value": "'$ZBX_MYSQL_ROOT_PASS'"
            },
            {
                "key": "MYSQL_CHECK_USER",
                "value": "'$ZBX_MYSQL_CHECK_USER'"
            },
            {
                "key": "MYSQL_CHECK_PASSWORD",
                "value": "'$ZBX_MYSQL_CHECK_PASS'"
            },
            {
                "key": "MYSQL_USER",
                "value": "'$ZBX_MYSQL_USER'"
            },
            {
                "key": "MYSQL_PASSWORD",
                "value": "'$ZBX_MYSQL_PASS'"
            },
            {
                "key": "MYSQL_DATABASE",
                "value": "'$ZBX_MYSQL_DATABASE'"
            }
        	],
           "imageURI": "'$MYSQL_IMAGE_URI'",
           "imageversion": "'$MYSQL_IMAGE_VERSION'",
           "constraints": [["ip", "LIKE", "'$ZBX_MYSQL_IP'" ], ["ip", "UNIQUE"]], 
           "network": "HOST"
        }'
