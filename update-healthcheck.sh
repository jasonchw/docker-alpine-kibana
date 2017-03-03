#!/bin/bash

if [ "X${KIBANA_REMOTE_ACCESS}" == "Xtrue" ]; then
    echo "Allow remote access to Kibana"
else
    if [ -n "$CONSUL_BIND_INTERFACE" ]; then
        CONSUL_BIND_ADDRESS=$(ip -o -4 addr list $CONSUL_BIND_INTERFACE | head -n1 | awk '{print $4}' | cut -d/ -f1)
        if [ -z "$CONSUL_BIND_ADDRESS" ]; then
            echo "Could not find IP for interface '$CONSUL_BIND_INTERFACE', exiting"
            exit 1
        fi

        sed -i -e "s#\"script\".*#\"script\" : \"nmap ${CONSUL_BIND_ADDRESS} -PN -p 5601 | grep open\",#" /etc/consul.d/kibana.json
        sed -i -e "s#nmap.*#nmap ${CONSUL_BIND_ADDRESS} -PN -p 5601 | grep open#" /usr/local/bin/healthcheck.sh
    fi
fi

