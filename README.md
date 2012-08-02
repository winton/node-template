#NodeTemplate

Node.js project template.

##Install

	npm install node_template -g

##Create a new project

	node_template my_project
	cd my_project

##Compile CoffeeScript (watch ./src)

	npm start

##Run tests

	npm test

##Template branches

* [express](https://github.com/winton/node_template/tree/express)
* [express-backbone](https://github.com/winton/node_template/tree/express-backbone)
* [express-backbone-everyauth](https://github.com/winton/node_template/tree/express-backbone-everyauth)
* [express-backbone-redis](https://github.com/winton/node_template/tree/express-backbone-redis)

To use a template branch:

	node_template -b express my_project

Multiple branches are okay:

	node_template -b express-backbone-everyauth -b express-backbone-redis my_project

##Dependencies

###Production

* [Async](https://github.com/caolan/async)
* [Underscore](http://documentcloud.github.com/underscore)

###Development

* [CoffeeScript](http://coffeescript.org)
* [Colors.js](https://github.com/marak/colors.js)
* [Glob](https://github.com/isaacs/node-glob)
* [Mocha](http://visionmedia.github.com/mocha)
* [Sinon](http://sinonjs.org)

###Install

Install [shrinkwrapped](http://npmjs.org/doc/shrinkwrap.html) and/or new dependencies:

	cake install

This runs automatically upon creating a project.

##Publish

Shrinkwraps, commits, and tags with version:

	cake publish

## Contribute

[Create an issue](https://github.com/winton/node_template/issues/new) to discuss template changes.

Pull requests for template changes and new branches are even better.

## Stay up to date

[Watch this project](https://github.com/winton/node_template#) on Github.

[Follow Winton Welsh](http://twitter.com/intent/user?screen_name=wintonius) on Twitter.