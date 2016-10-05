#!/usr/local/bin/dumb-init /bin/bash

exec start-consul.sh &
exec start-kibana.sh

