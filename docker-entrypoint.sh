#!/usr/local/bin/dumb-init /bin/bash

exec update-healthcheck.sh &
exec start-consul.sh &
exec start-kibana.sh

