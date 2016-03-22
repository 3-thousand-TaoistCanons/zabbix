#!/bin/bash
. ../config.cfg
token=`./get_token.sh`

curl -X POST $BASE_URL/api/v3/clusters/$SRY_CLUSTERID/apps \
        -H Authorization:$token \
        -H Content-Type:application/json -d '{
           "name": "'${SERVICE_PRE}'-web",
           "cluster_id": "'$SRY_CLUSTERID'",
           "cpus": 0.2,
           "mem": 1024,
           "instances": 1,
           "volumes": [],
           "imageName": "'$ZBX_WEB_IMAGE_URI'",
           "imageVersion": "'$ZBX_WEB_IMAGE_VERSION'",
           "forceImage": false,
           "unique": true,
           "constraints": [], 
           "network": "HOST",
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
          "constraints": [["ip", "LIKE", "'$ZBX_WEB_IP'" ], ["ip", "UNIQUE"]],
          "logPaths": []
        }'
