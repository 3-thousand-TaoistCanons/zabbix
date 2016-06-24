#!/bin/bash
# shurenyun get token
. ../config.cfg

token=`cat /tmp/sry-api-${SRY_USER}-token 2>/dev/null`
code=`curl -X GET --header "Accept: application/json" --header "Authorization: $token"  "$BASE_URL/api/v3/auth" 2>/dev/null |python -m json.tool| awk -F ':|"|,|' '/code/{print $4}'`
if [ -z "$code" ] || [ "$code" -ne 0 ];then
	token=`curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -d "{
		\"name\":\"${SRY_USER}\",
		\"password\":\"${SRY_PASS}\"
	}" "$BASE_URL/api/v3/auth" 2>/dev/null |python -m json.tool|awk -F ':|"' '/token/{print $5}' `
	echo "$token" > /tmp/sry-api-${SRY_USER}-token
fi
echo $token

