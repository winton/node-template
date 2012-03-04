fs = require 'fs'

common =
  async: require('async')
  crypto: require('crypto')
  underscore: require('underscore')

common.secret = common.crypto
  .createHash('sha256')
  .update(";node_template!@#$%^&*(69)")
  .digest('hex')

common.config = fs.readFileSync("#{__dirname}/../config/node_template.json")
common.config = JSON.parse(common.config)[process.env.NODE_ENV || 'development']

module.exports = common