for key, value of require('./node-template/common')
  eval("var #{key} = value;")

module.exports = class NodeTemplate
  constructor: ->
    @bookshelf = @loadBookshelf()

  @glob: (path) ->
    [ promise, resolve ] = defer()
    glob path, (e, files) => resolve(files)
    promise

  loadBookshelf: ->
    NodeTemplate.loadBookshelf().spread (db, classes) =>
      @db = db
      _.extend(@, classes)
      Q.resolve([ db, classes ])

  @loadBookshelf: ->
    [ promise, resolve, reject ] = defer()

    config = JSON.parse(
      fs.readFileSync(
        path.resolve(__dirname, "../config/database.json")
      )
    )

    db = Bookshelf.Initialize(config)
    @glob("#{__dirname}/node-template/models/**/*.js").then (files) =>
      classes = _.reduce(files
        (obj, file) =>
          _.extend(obj, require(file))
        {}
      )
      resolve([ db, classes ])

    promise