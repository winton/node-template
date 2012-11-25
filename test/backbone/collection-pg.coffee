# Common

require('../../lib/common')(this)

# Run if adapter active

if @config.adapter == 'pg'

  # Specs

  describe 'CollectionPg', =>

    before (done) =>
      @query("DELETE from models").then(
        -> done()
      ).done()

    describe '.findBy', =>
      it 'should find the records', (done) =>
        models = [
          new @Model(name: 'test')
          new @Model(name: 'test')
          new @Model(name: 'test2')
        ]
        models[0].save({}).then(
          => models[1].save({})
        ).then(
          => models[2].save({})
        ).then(
          => @Collection.findBy(name: 'test')
        ).then(
          (records) =>
            records.length.should.equal(2)
            records.each (record, i) ->
              record.attributes.should.eql(models[i].attributes)
            done()
        ).done()