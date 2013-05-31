common =
  fs  : require('fs')
  path: require('path')
  Q   : require('q')
  _   : require('underscore')

common.defer = ->
  d = common.Q.defer()
  return [ d.promise, d.reject, d.resolve ]

module.exports = common