require('colors')
_  = require('underscore')

module.exports = (instance) ->

  common = {}

  # Config

  common.config = config = require('./common/config')

  # Libraries

  common.express = require('express')

  _.extend(
    common
    _           : _
    async       : require('async')
    crypto      : require('crypto')
    request     : require('request')
    ConnectRedis: require('connect-redis')(common.express)
    Q           : require('q')
  )

  # Functions

  _.extend(
    common
    require('./common/functions')
    
    bind: (instance) ->
      for key, value of common
        instance[key] = value

      common.dependencies (deps) ->
        for key, value of deps
          instance[key] = value
    
    sessionGate: (req, res, next) ->
      sessions_disabled = [
        "/up"
      ]
      if sessions_disabled.indexOf(req.url.split('?')[0]) > -1
        next()
      else
        common.session(req, res, next)
  )

  # Objects

  express = common.express
  app     = express()

  common.app      = app
  common.node_env = process.env.NODE_ENV || 'development'
  common.redis    = common.setupRedis()

  common.secret = common.crypto
    .createHash('sha256')
    .update(config.secret)
    .digest('hex')

  common.session = common.express.session(
    cookie:
      path    : '/'
      httpOnly: true
      maxAge  : 365 * 24 * 60 * 60 * 1000
    store: new common.ConnectRedis(
      host: config.redis.host
      port: config.redis.port
    )
    secret: common.secret
  )

  # Configuration

  app.configure ->
    app.use express.static("#{__dirname}/../public")
    app.use express.bodyParser()
    app.use express.cookieParser()
    app.use express.logger()
    app.use express.methodOverride()
    app.use common.sessionGate

  # Postgres adapter

  if config.adapter == 'pg'
    common.Backbone   = require('backbone-postgresql')
    common.Collection = require('./backbone/collection-pg')(common.Backbone)
    common.Model      = require('./backbone/model')(common.Backbone)

    common.Backbone.pg_connector.config =
      db: "pg://#{config.pg.host}/#{config.pg.db}"

  # Redis adapter

  if config.adapter == 'redis'
    common.Backbone      = require('backbone')
    common.Backbone.sync = require('./backbone/sync-redis')(common.Backbone)
    common.Collection    = require('./backbone/collection-redis')(common.Backbone)
    common.Model         = require('./backbone/model-redis')(common.Backbone)

  # Bind

  common.bind(instance) if instance

  # Return common

  common