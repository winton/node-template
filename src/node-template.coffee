for key, value of require('./node-template/common')
  eval("var #{key} = value;")

Bookshelf = require("bookshelf")
fs        = require("fs")
glob      = require("glob")
path      = require("path")

module.exports = class NodeTemplate
  constructor: ->
    config = JSON.parse(
      fs.readFileSync(
        path.resolve(__dirname, "../config/database.json")
      )
    )

    @db = Bookshelf.Initialize(config)
    @glob("#{__dirname}/node-template/models/**/*.js").then(
      (files) =>
        _.each(
          files
          (file) =>
            _.extend(@, require(file))
        )
    )

  glob: (path) ->
    defer (resolve, reject) =>
      glob path, (e, files) =>
        resolve(files)