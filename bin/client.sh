#!/bin/bash

# If command is 'start' and (development or no env specified)
if [ $1 = 'start' ] && ([ "$NODE_ENV" = 'development' ] || [ -z "$STATE" ]); then
	cd client
	stasis -p ../public -d
fi

# If command is 'start' and production
if [ $1 = 'start' ] && [ "$NODE_ENV" = 'production' ]; then
	cd client
	stasis -p ../public
fi

# If command is 'new'
if [ $1 = 'new' ]; then
	cd ../ && \
	git init $2 && \
	cd $2 && \
	git remote add origin $3 && \
	git remote add template git://github.com/winton/node_template.git && \
	git fetch template && \
	git merge template/master && \
	cake install && \
	echo -e "\n\033[1;32mSuccess!\033[0m" && \
	echo -e "\n\033[1;33mStart your server:\033[0m cd ../$1 && cake start\n"
fi

# If command is 'bootstrap'
if [ $1 = 'bootstrap' ]; then
	pwd=`pwd`
	cd $2
	make bootstrap
	cp -f bootstrap/css/bootstrap.css $pwd/client/css/lib
	cp -f bootstrap/css/bootstrap-responsive.css $pwd/client/css/lib
	rm -rf $pwd/client/js/lib/bootstrap
	mkdir -p $pwd/client/js/lib/bootstrap
	cp -f js/*.js $pwd/client/js/lib/bootstrap
fi