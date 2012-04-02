fs = require 'fs'

common =
  async: require('async')
  crypto: require('crypto')
  underscore: require('underscore')

common.secret = common.crypto
  .createHash('sha256')
  .update(";node_template!@#$%^&*(69)")
  .digest('hex')

module.exports = common