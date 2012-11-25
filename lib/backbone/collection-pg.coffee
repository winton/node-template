module.exports = (Backbone) ->
  
  Collection = require('./collection')(Backbone)

  class CollectionPg extends Collection

    @findBy: (attributes) ->
      (new @).fetch(filter: attributes)