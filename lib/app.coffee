# Common

require('./common')(this)

# Exports

module.exports = @app

# Actions

@app.get '/up', (req, res) =>
  res.send(
    redis: @redis.ping()
  )