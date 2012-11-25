_    = require('underscore')
glob = require('glob')
path = require('path')
Q    = require('q')

config = require('./config')

module.exports =

  defer: Q.ncall
  
  dependencies: (fn) ->
    glob "#{__dirname}/../*.coffee", (e, paths) =>
      fn _.inject(
        paths
        (hash, p) ->
          klass = path.basename(p, '.coffee')
          klass = klass.replace(
            /(-[a-z]|^[a-z])/g
            ($1) -> $1.toUpperCase().replace('-','')
          )
          if [ "App", "Common", "Server" ].indexOf(klass) == -1
            hash[klass] = require(p)
          hash
        {}
      )

  error: (e, r) ->
    console.log("\nERROR CALLBACK")
    console.log(r.client._httpMessage.path)
    console.log(e)
    console.log('')

  promise: promise = (fn) ->
    d = Q.defer()
    fn(d.resolve, d.reject)
    d.promise
    
  setupRedis: ->
    require('redis').createClient(config.redis.port, config.redis.host)

  when: Q.fcall