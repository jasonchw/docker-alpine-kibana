#!/bin/bash

set -e

KIBANA_BIN=/opt/kibana/bin/kibana
KIBANA_LOG_DIR=/var/log/kibana
KIBANA_LOG_FILE=${KIBANA_LOG_DIR}/kibana.log
KIBANA_CONFIG_FILE=/opt/kibana/config/kibana.yml

set -- gosu kibana ${KIBANA_BIN} 

#sleep 5
#consul-template -consul localhost:8500 -once -template "/etc/consul-templates/30-output.conf.ctmpl:/tmp/30-output.conf"

if [ "${ELASTICSEARCH_URL}" ]; then
    sed -i -e "s#\# elasticsearch.url.*#elasticsearch.url: \"${ELASTICSEARCH_URL}\"#" ${KIBANA_CONFIG_FILE}
fi

sed -i -e "s#\# logging.dest.*#logging.dest: \"${KIBANA_LOG_FILE}\"#" ${KIBANA_CONFIG_FILE}

exec "$@"

