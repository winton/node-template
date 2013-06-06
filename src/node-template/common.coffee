common =
  Bookshelf: require('bookshelf')
  express  : require('express')
  fs       : require('fs')
  glob     : require("glob")
  Knex     : require("knex")
  path     : require('path')
  Q        : require('q')
  _        : require('underscore')

common.defer = ->
  d = common.Q.defer()
  [ d.promise, d.resolve, d.reject ]

module.exports = common