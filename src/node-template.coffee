for key, value of require('./node-template/common')
  eval("var #{key} = value;")

module.exports = class NodeTemplate
  constructor: ->
    @bookshelf().done()

  bookshelf: ->
    NodeTemplate.bookshelf().spread (db, classes) =>
      @db = db
      _.extend(@, classes)
      [ db, classes ]

  @bookshelf: ->
    return @_bookshelf  if @_bookshelf
    models = "#{__dirname}/node-template/models/**/*.js"

    @_bookshelf = @glob(models).then((files) =>
      [
        # db
        Bookshelf.Initialize(@config("../config/database.json"))
        
        # models
        _.reduce(files
          (obj, file) => _.extend(obj, require(file))
          {}
        )
      ]
    ).fail (e) =>
      delete @_bookshelf
      throw e

  @config: (json) ->
    config = path.resolve(__dirname, json)
    JSON.parse(fs.readFileSync(config))

  @glob: (path) ->
    Q.nfcall(glob, path)