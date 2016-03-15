#!/bin/bash
. ../config.cfg
token=`./get_token.sh`

curl -X POST $BASE_URL/api/v1/applications/deploy \
        -H Authorization:$token \
        -H Content-Type:application/json -d '{
           "appName": "'${SERVICE_PRE}'-web",
           "clusterId": "'$SRY_CLUSTERID'",
           "containerCpuSize": 0.2,
           "containerMemSize": 1024,
           "containerNum": "1",
           "envs": [
            {
                "key": "CONFIG_SERVER",
                "value": "http://'$CONFIGSERVER_IP':'$CONFIGSERVER_PORT'"
            },
            {
                "key": "SERVICE",
                "value": "zabbix/zabbix-web"
            },
            {
                "key": "NOHOSTNAME",
                "value": "true"
            }
        	],
           "imageURI": "'$ZBX_WEB_IMAGE_URI'",
           "imageversion": "'$ZBX_WEB_IMAGE_VERSION'",
           "unique": true,
           "constraints": [["ip", "LIKE", "'$ZBX_WEB_IP'" ], ["ip", "UNIQUE"]], 
           "network": "HOST"
        }'
