module.exports = (Backbone) ->

  Model = require('./model')(Backbone)

  class ModelPg extends Model

    @findBy: (attributes) ->
      (new @).fetch(filter: attributes)

    @findOrCreateBy: (attributes) ->
      @findBy(attributes).then(
        null
        => (new @).save(attributes)
      )