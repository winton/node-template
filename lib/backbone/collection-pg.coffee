module.exports = (Backbone) ->
  
  Collection = require('./collection')(Backbone)

  class CollectionPg extends Collection

    @findBy: (attributes) ->
    	filter = {}
    	for key, value of attributes
    	  filter[key] = "'#{value}'"
    	(new @).fetch(filter: filter)