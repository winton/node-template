for key, value of require('./node-template/common')
  eval("var #{key} = value;")

Bookshelf = require("bookshelf")
glob      = require("glob")

module.exports = class NodeTemplate
  constructor: ->
    @loadBookshelf()

  glob: (path) ->
    [ promise, resolve ] = defer()
    glob path, (e, files) => resolve(files)
    promise

  loadBookshelf: ->
    [ promise, resolve, reject ] = defer()

    config = JSON.parse(
      fs.readFileSync(
        path.resolve(__dirname, "../config/database.json")
      )
    )

    @db = Bookshelf.Initialize(config)
    @glob("#{__dirname}/node-template/models/**/*.js").then(
      (files) =>
        _.each files, (file) =>
          _.extend(@, require(file))
        resolve()
    )