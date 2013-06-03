##NodeTemplate

Node.js package template.

###Goals

* Templates utilize widely accepted practices
* Automate the creation and renaming of projects
* Projects share git history for easy updates
* Selectively add functionality with git [branches](https://github.com/winton/node-template/branches)

###Install

	npm install node-template -g

###Create a new project

	node-template <project-name> <branch>

Available branches:

* **master** - Base npm package template *(default)*
* [**bookshelf**](https://github.com/winton/node-template/tree/bookshelf) - Bookshelf.js database ORM
* [**express**](https://github.com/winton/node-template/tree/express) - Express.js web server
* [**bookshelf-express**](https://github.com/winton/node-template/tree/bookshelf-express) - Bookshelf + Express

###Start working

Run `grunt` to watch for changes in `src` and compile them to `lib`.

Run `npm test` to execute your test suite.

### Contribute

[Create an issue](https://github.com/winton/node-template/issues/new) to discuss template changes.

Pull requests for template changes and new branches are even better.

### Stay up to date

[Watch this project](https://github.com/winton/node-template#) on Github.

[Follow Winton Welsh](http://twitter.com/intent/user?screen_name=wintonius) on Twitter.
