node_env = process.env.NODE_ENV || 'development'

# Common dependencies

common = require './common'
async = common.async
Backbone = common.Backbone
redis = common.redis
secret = common.secret
_ = common.Underscore

# Express dependencies

express = require 'express'
app = module.exports = express.createServer()
connect_redis = require('connect-redis')(express)

# Middleware

session = express.session(
  cookie:
    path: '/'
    httpOnly: true
    maxAge: 365 * 24 * 60 * 60 * 1000
  secret: secret,
  store: new connect_redis
)

customSession = (req, res, next) ->
  if req.param('session') == '0'
    next()
  else
    session(req, res, next)

# Configure app

app.configure ->
  app.use express.static("#{__dirname}/../public")
  app.set 'views', "#{__dirname}/views"
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.logger()
  app.use express.methodOverride()
  app.use customSession

# Backbone

Backbone.sync = (method, model, options) ->
  path =
    if _.isFunction(model.url)
      model.url()
    else
      model.url
  
  unless model.models?
    id = path.match(r = /\/([^\/]+)$/)[1]
    path = path.replace(r, '')
  
  success = options.success

  switch method
    when "create", "update"
      redis.hset path, id, JSON.stringify(model), ->
        if options.scope
          redis.sadd options.scope, path, -> success()
        else
          success()
    when "read"
      if id
        redis.hget path, id, (e, json) ->
          success(JSON.parse(json))
      else if options.scope
        redis.smembers path, (e, keys) ->
          fns = _.map keys, (key) ->
            (callback) ->
              redis.hgetall key, (e, hash) ->
                callback(null,
                  _.map _.values(hash), (json) -> JSON.parse(json)
                )
          async.parallel fns, (err, results) ->
            success(_.flatten(results))
      else
        redis.hgetall path, (e, hash) ->
          success(
            _.map _.values(hash), (json) -> JSON.parse(json)
          )
    when "delete"
      redis.hdel path, id, ->
        if options.scope
          redis.hlen path, (e, len) ->
            if len == 0
              redis.srem options.scope, path, -> success()
        else
          success()

# Actions

app.get('/test', (req, res) ->
  res.send test: 1
)

# Start server

unless module.parent
  app.listen 8080
  console.log 'Node.js started on port 8080'