for key, value of require('./node-template/common')
  eval("var #{key} = value;")

module.exports = class NodeTemplate
  constructor: (port) ->
    @express = @loadExpress(port)

  @glob: (path) ->
    [ promise, resolve ] = defer()
    glob path, (e, files) => resolve(files)
    promise

  loadExpress: (port) ->
    NodeTemplate.loadExpress(port).spread (app, controllers) =>
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