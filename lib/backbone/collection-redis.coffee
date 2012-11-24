_ = require('underscore')

module.exports = (Backbone) ->
  
  Collection = require('./collection')(Backbone)

  class CollectionRedis extends Collection

    pathAndId: ->
      path = if _.isFunction(@url) then @url() else @url
      [ path, null ]