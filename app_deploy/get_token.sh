#!/bin/bash
# shurenyun get token
. ../config.cfg

token=`cat /tmp/sry-api-token 2>/dev/null`
code=`curl -X GET --header "Accept: application/json" --header "Authorization: $token"  "$BASE_URL/api/v2/auth" 2>/dev/null |python -m json.tool| awk -F ':|"|,|' '/code/{print $4}'`
if [ "$code" -ne 0 ];then
	token=`curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -d "{
		\"email\":\"${SRY_USER}\",
		\"password\":\"${SRY_PASS}\"
	}" "$BASE_URL/api/v2/auth" 2>/dev/null |python -m json.tool|awk -F ':|"' '/token/{print $5}' `
	echo "$token" > /tmp/sry-api-token
fi
echo $token

