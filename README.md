##NodeTemplate

Node.js package template.

###Goals

* Utilize widely accepted tools and libraries
* Automate the creation and renaming of projects
* Projects and templates share git history for easy updates
* Selectively add functionality with git [branches](https://github.com/winton/node-template/branches)

###Install

	npm install node-template -g

###Create a new project

	node-template <project-name> <branch>...

Available branches:

* **master** - Base npm package template. Default if no branch specified.
* [**bookshelf**](https://github.com/winton/node-template/tree/bookshelf) - ([Bookshelf.js](http://bookshelfjs.org)) database ORM
* [**express**](https://github.com/winton/node-template/tree/express) - ([Express.js](http://expressjs.com)) web server

###Start working

Run `grunt` to watch for changes in `src` and compile them to `lib`.

Run `npm test` to execute your test suite.

### Contribute

[Create an issue](https://github.com/winton/node-template/issues/new) to discuss template changes.

Pull requests for template changes and new branches are even better.

### Stay up to date

[Watch this project](https://github.com/winton/node-template#) on Github.

[Follow Winton Welsh](http://twitter.com/intent/user?screen_name=wintonius) on Twitter.
