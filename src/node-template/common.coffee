{ exec } = require "child_process"

common =
  EventEmitter: require('events').EventEmitter
  fs: require('fs')
  Q: require('q')
  _: require('underscore')

common.defer = (fn) ->
  d = common.Q.defer()
  fn(d.resolve, d.reject)
  d.promise

common.exec = (cmd) ->
  common.defer (resolve, reject) ->
  	exec cmd, => resolve()

module.exports = common