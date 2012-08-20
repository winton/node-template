common = require '../common'

Backbone = common.Backbone
_        = common.Underscore

async = common.async

module.exports = class RedisCollection extends Backbone.Collection

  destroyAll: (fn) ->
    fns = @map (record) -> (callback) ->
      record.destroy success: -> callback(null)
    async.parallel fns, -> fn()

  pathAndId: ->
    path = if _.isFunction(@url) then @url() else @url
    [ path, null ]

  toJSON: (options, fn) ->
    if options && options.methods
      fns = @map (record) -> (callback) ->
        record.toJSON methods: options.methods, (json) ->
          callback(null, json)
      async.parallel fns, (e, results) -> fn(results)
    super()