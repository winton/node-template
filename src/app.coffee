node_env = process.env.NODE_ENV || 'development'

# Dependencies

common = require './common'
async = common.async
Backbone = common.Backbone
crypto = common.crypto
rest = common.rest
secret = common.secret
_ = common.underscore

# Express

express = require 'express'
app = module.exports = express.createServer()

# Config

fs = require 'fs'
config = "#{__dirname}/../config/node_template.json"
config = JSON.parse(fs.readFileSync(config))[node_env]

# Middleware

session = express.session(
  cookie:
    path: '/'
    httpOnly: true
    maxAge: 365 * 24 * 60 * 60 * 1000
  secret: secret
)

# Configure app

app.configure ->
  app.use express.static("#{__dirname}/../public")
  app.set 'views', "#{__dirname}/views"
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.logger()
  app.use express.methodOverride()

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
  res.send(hello: 'world')

# Start server

unless module.parent
  port = if node_env == 'production' then 80 else 8080
  port = process.env.PORT if process.env.PORT
  app.listen port
  console.log "Node.js started on port #{port}"