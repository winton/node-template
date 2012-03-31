node_env = process.env.NODE_ENV || 'development'

# Dependencies

common = require './common'
async  = common.async
crypto = common.crypto
secret = common.secret
_      = common.underscore

# Express

express = require 'express'
app     = module.exports = express.createServer()

# Middleware

session = express.session(
  cookie:
    path: '/'
    httpOnly: true
    maxAge: 365 * 24 * 60 * 60 * 1000
  secret: secret
)

sessionGate = (req, res, next) ->
  # Sessions are disabled for these paths:
  no_session = [
    "/hello.json"
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

# Error handling

app.error (err, req, res, next) ->
  code = (Math.random() + '').substring(2)
  
  console.log("\nError - #{code} - #{(new Date()).toUTCString()}")
  console.log("#{req.method} #{req.url}")
  console.log(req.query)
  
  if req.headers['user-agent']
    console.log("#{req.headers['user-agent']}")
  
  console.log("\n#{err.stack}\n")
  res.send("Error reference code #{code}")

# Actions

app.get '/hello.json', session, (req, res) ->
  res.send(hello: 'holla')

# Start server

port = if node_env == 'production' then 80 else 8080
port = process.env.PORT if process.env.PORT
app.listen port
console.log "Node.js started on port #{port}"