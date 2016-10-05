#!/bin/bash

set -ex

nmap 127.0.0.1 -PN -p 5601 | grep open

