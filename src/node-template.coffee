for key, value of require('./node-template/common')
  eval("var #{key} = value;")

express = require("express")
glob    = require("glob")

module.exports = class NodeTemplate
  constructor: (port) ->
    @loadExpress(port)

  glob: (path) ->
    [ promise, resolve ] = defer()
    glob path, (e, files) => resolve(files)
    promise
  
  loadExpress: (port) ->
    [ promise, resolve, reject ] = Common.defer()

    @app = express(port)
    @app.configure =>
      @app.use express.static("#{__dirname}/../../public")
      @app.use express.bodyParser()
      @app.use express.cookieParser()
      @app.use express.logger()
      @app.use express.methodOverride()

    @glob("#{__dirname}/node-template/controllers/**/*.js").then(
      (files) =>
        _.each files, (file) =>
          for key, value of require(file)
            @[key] = new value(@app)      
        )

        if port
          @app.listen(port)
          console.log("NodeTemplate started on #{port}.")

        resolve()
    )
    
    promise