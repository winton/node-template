# Common

require('../../lib/common')(this)

# Run if adapter active

if @config.adapter == 'pg'

  # Specs

  describe 'ModelPg', =>

    last_id = null

    findOrCreate = =>
      @Model.findOrCreateBy(name: 'test')

    testRows = (rows) =>
      rows.length.should.equal 1
      rows[0].name.should.equal 'test'

    before (done) =>
      @query("DELETE from models").then(
        -> done()
      ).done()

    describe '.findBy', =>
      it 'should find the record', (done) =>
        model = new @Model(name: 'test')
        model.save({}).then(
          => @Model.findBy(name: 'test')
        ).then(
          (result) =>
            result.toJSON().should.eql(model.toJSON())
            done()
        ).done()

    describe '.findOrCreate', =>
      it 'should create the record if none exist', (done) =>
        findOrCreate().then(
          (repo) => @query("SELECT * FROM models")
        ).then(
          (result) =>
            rows = result.rows
            last_id = rows[0].id
            testRows(rows)
            done()
        ).done()

      it 'should find the existing record', (done) =>
        findOrCreate().then(
          (repo) => @query("SELECT * FROM models")
        ).then(
          (result) =>
            rows = result.rows
            last_id.should.equal(rows[0].id)
            testRows(rows)
            done()
        ).done()