#!/usr/bin/env python
__author__ = 'Liu Jinye'
import subprocess
import json

import requests

import socket
import fcntl
import struct

import traceback
import logging

class _NullHandler(logging.Handler):
    def emit(self, record):
        pass

logger = logging.getLogger(__name__)
logger.addHandler(_NullHandler())
logging.basicConfig(level=logging.ERROR)

def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])

def mapi(base_url,api_url):
    try:
        url = "%s%s"%(base_url,api_url)
        headers = {'Accept': 'application/json'}
        result = requests.get(url,headers=headers)
	logger.debug("%s%s result: %s"%(base_url,api_url,result.text))
        result_json = json.loads(result.text)
	return result_json
    except:
        logger.error(traceback.print_exc())
        return None	
	
def get_leader(base_url):
	api_url='/v2/leader'
	result_json = mapi(base_url,api_url)
	return result_json

def get_apps(base_url):
    try:
        apps = []
        api_url='/v2/apps'
        result_json = mapi(base_url,api_url)
        for app in result_json['apps']:
            apps.append({"{#APPID}":app['id']})
        return apps
    except:
        logger.error(traceback.print_exc())
        return None

if __name__ == "__main__":
    try:
        #localip = get_ip_address('eth0')
    	get_localip_cmd="ps aux|grep marathon.Main|grep -o '\-\-hostname .* \-\-'|awk '{print $2}'"
    	get_port_cmd="netstat -lntp|grep `ps aux|grep marathon.Main|grep -v grep|awk '{print $2}'`|grep -Eo '5098|8080'"

    	localip = subprocess.check_output(get_localip_cmd, shell=True).strip()
    	port = subprocess.check_output(get_port_cmd, shell=True).strip()
    	baseurl="http://%s:%s" %(localip,port)

    	result_json = get_leader(baseurl)
    	if result_json and "%s:%s"%(localip,port) == result_json['leader']:
    	    apps=get_apps(baseurl)
    	else:
    	    apps=[]

            data = {"data":apps}
            print json.dumps(data)
    except:
        logger.error(traceback.print_exc())
