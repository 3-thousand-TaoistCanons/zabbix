#!/usr/bin/env python

import os
import sys
import json
import requests
import socket
import tempfile
import subprocess

import traceback
import logging

class _NullHandler(logging.Handler):
    def emit(self, record):
        pass

logger = logging.getLogger(__name__)
logger.addHandler(_NullHandler())
#logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(levelname)s: %(message)s')
logging.basicConfig(level=logging.WARNING, format='%(asctime)s %(levelname)s: %(message)s')

host_name = socket.gethostname()
projects=["app", "cluster", "auth", "websocket", "streaming", "metrics", "log", "alert", "harbor", "billing"]
agent_conf="/etc/zabbix/zabbix_agentd.conf"

def _get_project_oridata(base_url):
	data = []
	for project_name in projects:
                project_url="%s/%s" %(base_url,project_name)
                try:
                        rt = requests.get(project_url)
                        ret=json.loads(rt.text)
                        for k,v in ret.items():
				data.append({"%s-%s"%(project_name,k):v})
                except:
                        #logger.error(traceback.print_exc())
			pass
	return data

def service_discovery(base_url):
	services=[]

	for project in _get_project_oridata(base_url): 
		for k in project.keys():
       			services.append({"{#SRY_SERVICE_NAME}":k})

	data = {"data":services}
	print json.dumps(data)

def _send_data(tmpfile):
        '''Send the data to Zabbix.'''
	args = 'zabbix_sender -c {0} -i {1} '
	if host_name:
	        args = args + " -s " + host_name
	cmd = args.format(agent_conf, tmpfile.name)
	logger.info("send cmd: %s"%cmd)
        process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE,
                                           stderr=subprocess.PIPE)
	out, err = process.communicate()
        logging.debug("Finished sending data")
        return_code = process.wait()
        logger.info("Found return code of " + str(return_code))

        if return_code != 0:
            logger.warning(out)
            logger.error(err)
        else:
            logger.debug(err)
            logger.debug(out)
        return return_code

def service_status_send(base_url):
        '''Prepare the data for sending'''
	data = _get_project_oridata(base_url)
	rdatafile = tempfile.NamedTemporaryFile(delete=False)
	for project in _get_project_oridata(base_url):
                for key,val in project.items():
			for k,v in val.items():
				zkey="shurenyun.service.%s[%s]"%(k,key)
				zval=v
	    			logger.debug("SENDER_DATA: - %s %s" % ( zkey, zval))
    				rdatafile.write("- %s %s\n" % (zkey, zval))
	rdatafile.close()
	returncode = _send_data(rdatafile)
	os.unlink(rdatafile.name)
	return returncode

if __name__ == "__main__":
	if len(sys.argv) < 2:
        	print "Usage: ./sys.argv[0] base_url"
	        sys.exit(1)
	#       base_url="http://devforward.dataman-inc.net/api/v3/health"
	if len(sys.argv) == 2:
		base_url=sys.argv[1]
		service_discovery(base_url)
	else:
		base_url=sys.argv[1]
		sys.exit(service_status_send(base_url))
	
