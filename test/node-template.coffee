NodeTemplate = require("../lib/node-template")

describe 'NodeTemplate', ->
  describe '#constructor', ->
    before ->
      new NodeTemplate

    it 'should', ->
      true.should.eql(true)