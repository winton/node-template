fs = require 'fs'

config = process.env.NODE_ENV || 'development'
config = fs.readFileSync("#{__dirname}/../config/#{config}.json")
config = JSON.parse(config)

common =
  async   : require('async')
  config  : config
  crypto  : require('crypto')

  setupRedis: ->
    redis = require('redis').createClient(config.redis.port, config.redis.host)
    redis.on "error", (err) -> console.log(err)
    redis

  Backbone  : require('backbone')
  Underscore: require('underscore')

common.redis  = common.setupRedis()
common.secret = common.crypto
  .createHash('sha256')
  .update(";node_template!@#$%^&*(69)")
  .digest('hex')

module.exports = common