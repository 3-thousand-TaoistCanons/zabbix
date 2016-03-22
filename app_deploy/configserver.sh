#!/bin/bash
. ../config.cfg
token=`./get_token.sh`

if [ -z "$BASE_DIR" ];then
	echo "BASE_DIR is empty!!!" && exit 1
fi

curl -X POST $BASE_URL/api/v3/clusters/$SRY_CLUSTERID/apps \
        -H Authorization:$token \
        -H Content-Type:application/json -d '{
           "name": "'${SERVICE_PRE}'-configserver",
					 "cluster_id": '$SRY_CLUSTERID',
           "cpus": 0.1,
           "mem": 512,
           "instances": 1,
           "volumes": [
            {
                "hostPath": "'${BASE_DIR}'/conf.d",
                "containerPath": "/etc/nginx/conf.d"
            },
	          {
                "hostPath": "'${BASE_DIR}'/config",
                "containerPath": "/data/config"
            },
            {
                "hostPath": "'${BASE_DIR}'/packages",
                "containerPath": "/data/packages"
            }
          ],
           "imageName": "'$NGINX_IMAGE_URI'",
           "imageVersion": "'$NGINX_IMAGE_VERSION'",
					 "forceImage": false,
           "constraints": [["ip", "LIKE", "'$CONFIGSERVER_IP'" ], ["ip", "UNIQUE"]],
           "network": "BRIDGE",
	         "envs":[],
					 "portMappings": [{"protocol": 1, "type": 2, "isUri": 0, "uri": "", "appPort": 80, "mapPort": '$CONFIGSERVER_PORT'}],
					 "logPaths": []
        }'
