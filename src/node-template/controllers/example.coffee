for key, value of require('../common')
  eval("var #{key} = value;")

module.exports =
  ExampleController: class
    constructor: (app) ->
      
      # GET /up
      app.get '/up', (req, res) =>
        res.send(true)