Bookshelf     = require("bookshelf")
NodeTemplate  = require("../lib/node-template")
node_template = null

describe 'NodeTemplate', ->
  describe '#constructor', ->
    before ->
      node_template = new NodeTemplate

    it 'should return an instance of NodeTemplate', ->
      node_template.should.be.an.instanceof(NodeTemplate)

    it 'should load bookshelf', (done) ->
      node_template.bookshelf().spread (db, classes) ->
        db.should.be.an.instanceof(Object)
        classes.should.be.an.instanceof(Object)
        done()