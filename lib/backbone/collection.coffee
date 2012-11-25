async    = require('async')
_        = require('underscore')

module.exports = (Backbone) ->
  class Collection extends Backbone.Collection

    model  : require('./model')(Backbone)
    urlRoot: '/models'

    destroyAll: (fn) ->
      fns = @map (record) ->
        (callback) -> record.destroy success: -> callback(null)
      async.parallel fns, -> fn()

    toJSON: (options, fn) ->
      if options && options.methods
        fns = @map (record) -> (callback) ->
          record.toJSON methods: options.methods, (json) ->
            callback(null, json)
        async.parallel fns, (e, results) -> fn(results)
      super()