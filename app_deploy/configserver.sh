#!/bin/bash
. ../config.cfg
token=`./get_token.sh`

if [ -z "$BASE_DIR" ];then
	echo "BASE_DIR is empty!!!" && exit 1
fi

curl -X POST $BASE_URL/api/v1/applications/deploy \
        -H Authorization:$token \
        -H Content-Type:application/json -d '{
           "appName": "'${SERVICE_PRE}'-configserver",
           "clusterId": "'$SRY_CLUSTERID'",
           "containerCpuSize": 0.1,
           "containerMemSize": 512,
           "containerNum": "1",
           "containerVolumesInfo": [
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
           "imageURI": "'$NGINX_IMAGE_URI'",
           "imageversion": "'$NGINX_IMAGE_VERSION'",
           "constraints": [["ip", "LIKE", "'$CONFIGSERVER_IP'" ], ["ip", "UNIQUE"]],
           "network": "HOST",
	   "envs":[]
        }'
