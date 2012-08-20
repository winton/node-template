node_env = process.env.NODE_ENV ||= 'development'

# Dependencies

common = require './common'

Backbone = common.Backbone
_        = common.Underscore

async  = common.async
config = common.config
crypto = common.crypto
redis  = common.redis
secret = common.secret

# Backbone

Backbone.sync = require './backbone/redis-sync'

# Express

express = require 'express'
app     = module.exports = express()

# Sessions

RedisStore = require('connect-redis')(express)

session = express.session(
  cookie:
    path    : '/'
    httpOnly: true
    maxAge  : 365 * 24 * 60 * 60 * 1000
  store: new RedisStore(
    host: config.redis.host
    port: config.redis.port
  )
  secret: secret
)

sessionGate = (req, res, next) ->
  # Sessions are disabled for these paths:
  no_session = [
    "/"
    "/up"
    "/up/app"
    "/up/redis"
  ]
  if no_session.indexOf(req.url.split('?')[0]) > -1
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
  app.use sessionGate

# Actions

up = (req, res) -> redis.ping (e, r) -> res.send(app: true, redis: r == 'PONG')
app.get '/',   up
app.get '/up', up
app.get '/up/app',   (req, res) -> res.send(true)
app.get '/up/redis', (req, res) -> redis.ping (e, r) -> res.send(r == 'PONG')