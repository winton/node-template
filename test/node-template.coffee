NodeTemplate  = require("../lib/node-template")
node_template = null

describe 'NodeTemplate', ->
  describe '#constructor', ->
    before ->
      node_template = new NodeTemplate

    it 'should return an instance of NodeTemplate', ->
      node_template.should.be.an.instanceof(NodeTemplate)