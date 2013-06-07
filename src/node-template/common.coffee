common =
  AWS    : require('aws-sdk')
  express: require('express')
  fs     : require('fs')
  glob   : require('glob')
  path   : require('path')
  Q      : require('q')
  _      : require('underscore')

common.defer = ->
  d = common.Q.defer()
  [ d.promise, d.resolve, d.reject ]

module.exports = common