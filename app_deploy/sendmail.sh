#!/bin/bash
. ../config.cfg
token=`./get_token.sh`

curl -X POST $BASE_URL/api/v1/applications/deploy \
        -H Authorization:$token \
        -H Content-Type:application/json -d '{
           "appName": "'${SERVICE_PRE}'-sendmail",
           "clusterId": "'$SRY_CLUSTERID'",
           "containerCpuSize": 0.1,
           "containerMemSize": 512,
           "containerNum": "1",
           "envs": [
            {
		"key": "ORIGIN_KEY",
		"value": "'$MAIL_ORIGIN_KEY'"
            },
            {
                "key": "MAIL_HOST",
                "value": "'$MAIL_HOST'"
            },
	    {
		"key": "MAIL_USER",
		"value": "'$MAIL_USER'"
	    },
            {
                "key": "MAIL_PASS",
                "value": "'$MAIL_PASS'"
            },
            {
                "key": "MAIL_POSTFIX",
                "value": "'$MAIL_POSTFIX'"
            },
            {
                "key": "MAIL_DEBUG",
                "value": "'$MAIL_DEBUG'"
            },
            {
                "key": "MAIL_PORT",
                "value": "'$MAIL_PORT'"
            }
        	],
           "imageURI": "'$SENDMAIL_IMAGE_URI'",
           "imageversion": "'$SENDMAIL_IMAGE_VERSION'",
           "unique": true,
           "constraints": [["ip", "LIKE", "'$SENDMAIL_IP'" ], ["ip", "UNIQUE"]], 
           "network": "HOST"
        }'
