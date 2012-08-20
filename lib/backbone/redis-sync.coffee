common = require '../common'
Model  = require './redis-model'

_ = common.Underscore

async  = common.async
redis  = common.redis

# Helpers

isPlural = (str) -> str.substring(str.length-1) == 's'

# Backbone.sync

module.exports = (method, model, options) ->
  [ path, id ] = model.pathAndId()
  path_id      = [ path, id ].join('/')
  success      = options.success

  switch method
    when "create", "update"
      redis.hget path, id, (e, json) ->
        if json
          old     = JSON.parse(json)
          changes = model.changes()
          json    = _.extend(old, changes.modified)
          diff    = _.difference(changes.removed, _.keys(model.toJSON()))

          _.each diff, (key) -> delete json[key]
          model.set(json, silent: true)
          model._first_version = json
        else
          json = model
        redis.hset path, id, JSON.stringify(json), ->
          if options.scopes && options.scopes.length
            fns = _.map options.scopes, (scope) ->
              scope_path = if isPlural(scope) then path else path_id
              (callback) -> redis.sadd(scope, scope_path, -> callback(null))
            async.parallel(fns, (err, results) -> success())
          else
            success()
    when "read"
      if id
        redis.hget path, id, (e, json) ->
          success(JSON.parse(json))
      else if options.scope
        plural = isPlural(options.scope)
        redis.smembers options.scope, (e, keys) ->
          fns = _.map keys, (key) ->
            (callback) ->
              if plural
                redis.hgetall key, (e, hash) ->
                  callback(null, _.map(_.values(hash), (json) -> JSON.parse(json)))
              else
                [ path, id ] = Model.pathAndId(key)
                redis.hget(path, id, (e, record) -> callback(null, JSON.parse(record)))
          async.parallel fns, (err, results) ->
            success(_.flatten(results), true)
      else
        redis.hgetall path, (e, hash) ->
          success(_.map(_.values(hash), (json) -> JSON.parse(json)))
    when "delete"
      redis.hdel path, id, ->
        if options.scopes && options.scopes.length
          fns = _.map options.scopes, (scope) ->
            (callback) ->
              plural = isPlural(scope)
              if plural
                redis.hlen path, (e, len) ->
                  if len == 0
                    redis.srem scope, path, ->
                      model._first_version = {}
                      callback(null)
                  else
                    callback(null)
              else
                redis.srem scope, path_id, ->
                  model._first_version = {}
                  callback(null)
          async.parallel(fns, (err, results) -> success())
        else
          model._first_version = {}
          success()