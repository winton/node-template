#!/bin/bash

# If command is 'start' and (development or no env specified)
if [ $1 = 'start' ] && ([ "$NODE_ENV" = 'development' ] || [ -z "$NODE_ENV" ]); then
	./node_modules/.bin/supervisor -e 'js|coffee' -w 'server,node_modules' server/app.js
fi

# If command is 'start' and production
if [ $1 = 'start' ] && [ "$NODE_ENV" = 'production' ]; then
	export NODE_PATH=/usr/lib/node_modules 
	export NODE_ENV=production
	PORT=$2 /usr/bin/node server/app.js >> log/production.$2.log 2>&1
fi