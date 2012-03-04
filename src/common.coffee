common =
  async: require('async')
  Backbone: require('backbone')
  crypto: require('crypto')
  rest: require('restler')
  underscore: require('underscore')

common.secret = common.crypto
  .createHash('sha256')
  .update(";node_template!@#$%^&*(69)")
  .digest('hex')

module.exports = common