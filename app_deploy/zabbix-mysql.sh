#!/bin/bash
. ../config.cfg
token=`./get_token.sh`

curl -X POST $BASE_URL/api/v3/clusters/$SRY_CLUSTERID/apps \
        -H Authorization:$token \
        -H Content-Type:application/json -d '{
           "name": "'${SERVICE_PRE}'-mysql",
           "clusterId": "'$SRY_CLUSTERID'",
           "cpus": 1,
           "mem": 1024,
           "containerPortsInfo": [],
           "instances": 1,
           "volumes": [
            {
                "containerPath": "/var/lib/mysql",
                "hostPath": "/data/lib/mysql"
            }
           ],
           "imageName": "'$MYSQL_IMAGE_URI'",
           "imageVersion": "'$MYSQL_IMAGE_VERSION'",
           "forceImage": false,
           "constraints": [],
           "network": "HOST",
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
           "portMappings":[],
					 "logPaths": []
        }'
