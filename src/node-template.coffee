for key, value of require('./node-template/common')
  eval("var #{key} = value;")

module.exports = class NodeTemplate
  constructor: (port) ->
    @express(port).done()

  @config: (json) ->
    config = path.resolve(__dirname, json)
    JSON.parse(fs.readFileSync(config))

  express: (port) ->
    NodeTemplate.express(port).spread (app, controllers) =>
      @app = app
      _.extend(@, controllers)
      [ app, controllers ]
  
  @express: (port) ->
    return @_express  if @_express
    controllers = "#{__dirname}/node-template/controllers/**/*.js"

    @glob(controllers).then((files) =>
      app = express(port)

      app.configure =>
        app.use express.static("#{__dirname}/../../public")
        app.use express.bodyParser()
        app.use express.cookieParser()
        app.use express.logger()
        app.use express.methodOverride()

      classes = _.reduce(files
        (obj, file) =>
          _.extend(obj, require(file))
        {}
      )

      if port
        app.listen(port)
        console.log("NodeTemplate started on #{port}.")

      [ app, classes ]
    ).fail (e) =>
      delete @_express
      throw e

  @glob: (path) ->
    Q.nfcall(glob, path)