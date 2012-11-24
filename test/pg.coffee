# Common

common = require('./common')
eval("#{key} = value") for key, value of common

# Run if adapter active

if config.adapter == 'pg'

  # Specs

  describe 'Postgres', ->

    last_id = null

    findOrCreate = ->
      Model.findOrCreateBy(name: 'test')

    testRows = (rows) ->
      rows.length.should.equal 1
      rows[0].name.should.equal 'test'

    before (done) ->
      pg.query "DELETE from repos", -> done()

    describe 'beforeEach', ->
      it 'should create test repo', (done) ->
        findOrCreate().then(
          (repo) ->
            pg.query "SELECT * FROM repos", (e, result) ->
              rows = result.rows
              last_id = rows[0].id
              testRows(rows)
              done()
        )

      it 'should find the existing test repo', (done) ->
        findOrCreate().then(
          (repo) ->
            pg.query "SELECT * FROM repos", (e, result) ->
              rows = result.rows
              last_id.should.equal(rows[0].id)
              testRows(rows)
              done()
        )