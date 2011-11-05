process.env.NODE_ENV ||= 'development'

require.paths.push '/usr/local/lib/node_modules'

express = require 'express'
app = module.exports = express.createServer()

redis = require 'redis'
redis_store = require('connect-redis')(express)

app.configure () ->
  app.use express.static("#{__dirname}/../public")
  app.set 'views', "#{__dirname}/views"
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.logger()
  app.use express.methodOverride()
  app.use express.session(
    secret: "node_template123!@#",
    store: new redis_store
  )

app.get('/test', (req, res) ->
  res.send test: 1
)

unless module.parent
  app.listen 8080
  console.log 'Node.js started on port 8080'