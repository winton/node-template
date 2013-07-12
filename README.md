##NodeTemplate - bookshelf + express

Node.js web server with a database ORM.

###Goals

* Use widely accepted practices and libraries
* Automate the creation and renaming of projects
* Projects share git history for easy updates
* Add functionality through template [branches](https://github.com/winton/node-template/branches)

###Install

	npm install node-template -g

###Create a new project

	node-template <project-name> bookshelf-express

Other available branches:

* **master** - Base npm package template *(default)*
* [**aws-dynamo**](https://github.com/winton/node-template/tree/aws-dynamo) - Dynamo DB
* [**aws-dynamo-express**](https://github.com/winton/node-template/tree/aws-dynamo-express) - Dynamo DB + Express
* [**bookshelf**](https://github.com/winton/node-template/tree/bookshelf) - Bookshelf.js database ORM
* [**express**](https://github.com/winton/node-template/tree/express) - Express.js web server

###Coffeescript (optional)

Run `grunt` to watch for Coffeescript changes in `src` and compile them to `lib`.

###Start working

Run `bin/<project-name>` to start the web server.

Run `grunt` to watch for changes in `src` and compile them to `lib`.

###Tests

Run `grunt mocha` to execute your test suite with coverage statistics.

The `npm test` command runs the test suite without coverage (Travis-CI).

### Contribute

[Create an issue](https://github.com/winton/node-template/issues/new) to discuss template changes.

Pull requests for template changes and new branches are even better.

### Stay up to date

[Watch this project](https://github.com/winton/node-template#) on Github.

[Follow Winton Welsh](http://twitter.com/intent/user?screen_name=wintonius) on Twitter.
