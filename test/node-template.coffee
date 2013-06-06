express       = require("express")
NodeTemplate  = require("../lib/node-template")
node_template = null

describe 'NodeTemplate', ->
  describe '#constructor', ->
    before ->
      node_template = new NodeTemplate

    it 'should return an instance of NodeTemplate', ->
      node_template.should.be.an.instanceof(NodeTemplate)

     it 'should load express', (done) ->
      node_template.express.spread (app, controllers) ->
        app.should.be.an.instanceof(Object)
        controllers.should.be.an.instanceof(Object)
        done()