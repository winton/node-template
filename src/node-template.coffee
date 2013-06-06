for key, value of require('./node-template/common')
  eval("var #{key} = value;")

module.exports = class NodeTemplate

  constructor: (port) ->
    @bookshelf = @loadBookshelf().then =>
      @express = @loadExpress(port)

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

  loadExpress: ->
    NodeTemplate.loadExpress().spread (app, controllers) =>
      @app = app
      _.extend(@, controllers)
      Q.resolve([ app, controllers ])
  
  @loadExpress: (port) ->
    [ promise, resolve, reject ] = defer()

    app = express(port)
    app.configure =>
      app.use express.static("#{__dirname}/../../public")
      app.use express.bodyParser()
      app.use express.cookieParser()
      app.use express.logger()
      app.use express.methodOverride()

    @glob("#{__dirname}/node-template/controllers/**/*.js").then (files) =>
      controllers = _.reduce(files
        (obj, file) =>
          _.extend(obj, require(file))
        {}
      )

      if port
        app.listen(port)
        console.log("NodeTemplate started on #{port}.")

      resolve([ app, controllers ])

    promise