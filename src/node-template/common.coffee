common =
  Q: require('q')
  _: require('underscore')

common.defer = (fn) ->
  d = common.Q.defer()
  fn(d.resolve, d.reject)
  d.promise

module.exports = common