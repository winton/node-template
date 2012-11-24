_ = require('underscore')

module.exports = (Backbone) ->

  class Model extends Backbone.Model

    toJSON: (options, fn) ->
      json = super()
      if options && options.methods
        _.map options.methods, (method) =>
          @[method] (result) ->
            json[method] = result
            fn(json)
      json