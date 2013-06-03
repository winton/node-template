common =
  fs  : require('fs')
  path: require('path')
  Q   : require('q')
  _   : require('underscore')

common.defer = ->
  d = common.Q.defer()
  [ d.promise, d.resolve, d.reject ]

module.exports = common