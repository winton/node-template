# Common

require('../lib/common')(this)

# Run if adapter active

if @config.adapter == 'pg'

  # Specs

  describe 'Postgres', =>

    last_id = null

    findOrCreate = =>
      @Model.findOrCreateBy(name: 'test')

    testRows = (rows) =>
      rows.length.should.equal 1
      rows[0].name.should.equal 'test'

    before (done) =>
      @query("DELETE from models").then(
        -> done()
      )

    describe 'beforeEach', =>
      it 'should create test model', (done) =>
        findOrCreate().then(
          (repo) => @query("SELECT * FROM models")
        ).then(
          (result) =>
            rows = result.rows
            last_id = rows[0].id
            testRows(rows)
            done()
        )

      it 'should find the existing test model', (done) =>
        findOrCreate().then(
          (repo) => @query("SELECT * FROM models")
        ).then(
          (result) =>
            rows = result.rows
            last_id.should.equal(rows[0].id)
            testRows(rows)
            done()
        )