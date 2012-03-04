#!/bin/bash

export NODE_PATH=/usr/lib/node_modules 
export NODE_ENV=production

PORT=$1 /usr/bin/node /opt/node_template/current/lib/app.js >> /opt/node_template/shared/log/production.$1.log 2>&1