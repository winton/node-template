#!/bin/bash

./node_modules/.bin/supervisor -e 'js|coffee' -w 'server,node_modules' server/app.js