_ = require('underscore')

functions = require('../common/functions')
redis     = functions.setupRedis()

module.exports = (Backbone) ->

  Model = require('./model')(Backbone)

  class ModelRedis extends Model

    initialize: (attributes, options) ->
      @_first_version = @toJSON()
      super(attributes, options)

    changes: (keys) ->
      if @_first_version
        now      = @toJSON()
        old      = @_first_version || {}
        modified = {}
        removed  = []
        for key, value of old
          removed.push(key) unless now[key]?
        for key, value of now
          unless _.isEqual(old[key], value)
            modified[key] = value
        modified: modified, removed: removed
      else
        modified: @toJSON(), removed: []

    exists: (fn) ->
      if @get('id')
        redis.hget @urlRoot, @get('id'), (e, json) ->
          fn(json?)
      else fn(false)

    @pathAndId: (path) ->
      id   = unescape(path.match(r = /\/([^\/]+)$/)[1])
      path = path.replace(r, '')
      [ path, id ]

    pathAndId: ->
      path = if _.isFunction(@url) then @url() else @url
      ModelRedis.pathAndId(path)