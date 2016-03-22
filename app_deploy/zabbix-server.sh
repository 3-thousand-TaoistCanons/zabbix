#!/bin/bash
. ../config.cfg
token=`./get_token.sh`

curl -X POST $BASE_URL/api/v3/clusters/$SRY_CLUSTERID/apps \
        -H Authorization:$token \
        -H Content-Type:application/json -d '{
           "name": "'${SERVICE_PRE}'-server",
           "cluster_id": "'$SRY_CLUSTERID'",
           "cpus": 0.5,
           "mem": 512,
           "instances": 1,
           "volumes": [],
           "imageName": "'$ZBX_SERVER_IMAGE_URI'",
           "imageVersion": "'$ZBX_SERVER_IMAGE_VERSION'",
           "forceImage": false,
           "constraints": [["ip", "LIKE", "'$ZBX_SERVER_IP'" ], ["ip", "UNIQUE"]],
           "network": "HOST",
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
          "portMappings":[],
          "logPaths": []
        }'
