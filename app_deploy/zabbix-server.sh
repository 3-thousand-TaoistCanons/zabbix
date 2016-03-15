#!/bin/bash
. ../config.cfg
token=`./get_token.sh`

curl -X POST $BASE_URL/api/v1/applications/deploy \
        -H Authorization:$token \
        -H Content-Type:application/json -d '{
           "appName": "'${SERVICE_PRE}'-server",
           "clusterId": "'$SRY_CLUSTERID'",
           "containerCpuSize": 0.5,
           "containerMemSize": 2048,
           "containerNum": "1",
           "envs": [
            {
                "key": "CONFIG_SERVER",
                "value": "http://'$CONFIGSERVER_IP':'$CONFIGSERVER_PORT'"
            },
            {
                "key": "SERVICE",
                "value": "zabbix/zabbix-server"
            },
            {
                "key": "NOHOSTNAME",
                "value": "true"
            }
        	],
           "imageURI": "'$ZBX_SERVER_IMAGE_URI'",
           "imageversion": "'$ZBX_SERVER_IMAGE_VERSION'",
           "constraints": [["ip", "LIKE", "'$ZBX_SERVER_IP'" ], ["ip", "UNIQUE"]],
           "network": "HOST"
        }'
