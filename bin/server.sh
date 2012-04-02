#!/bin/bash

./node_modules/.bin/supervisor -e js|coffee -w lib,node_modules server/app.js