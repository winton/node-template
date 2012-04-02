#!/bin/bash

export NODE_PATH=/usr/lib/node_modules 
export NODE_ENV=production

PORT=$1 /usr/bin/node /path/to/server/app.js >> /path/to/log/production.$1.log 2>&1