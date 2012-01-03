crypto = require 'crypto'

module.exports =
  async: require 'async'
  Backbone: require 'backbone'
  redis: require('redis').createClient()
  secret: crypto
    .createHash('sha256')
    .update("node_template!!!*&^%$#123")
    .digest('hex')
  Underscore: require 'underscore'