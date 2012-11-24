_        = require('underscore')
glob     = require('glob')
path     = require('path')
postgres = require('pg').native
Q        = require('q')

config = require('./config')

pg  = null
pg2 = null

functions =

  addColumns: (name, cols) =>
    promise (resolve, reject) =>
      migrate = process.env.MIGRATE
      action  = if migrate == 'up' then 'ADD' else 'DROP'

      columns = _.map(
        cols
        (col) -> "#{action} COLUMN #{col}"
      ).join(', ')

      sql = "ALTER TABLE #{name} #{columns};"
      
      pg.query sql, (err, result) ->
        if migrate == 'up'
          console.log("\nAdded columns to table '#{name}'".green)
        else if migrate == 'down'
          console.log("\nDropped columns from table '#{name}'".red)

        _.each cols, (col) -> console.log("  #{col}")
        resolve()

  createDatabase: (name) =>
    promise (resolve, reject) =>
      pg2.query "CREATE DATABASE #{name || config.pg.db};", (err, result) =>
        pg = setupPg()
        resolve()

  createTable: (name, cols) =>
    promise (resolve, reject) =>
      migrate = process.env.MIGRATE

      if migrate == 'up'
        sql = "CREATE TABLE #{name} (id SERIAL, #{cols.join(", ")});"
      else if migrate == 'down'
        sql = "DROP TABLE IF EXISTS #{name};"

      pg.query sql, (err, result) =>
        if migrate == 'up'
          console.log("\nCreated table '#{name}'".green)
        else if migrate == 'down'
          console.log("\nDropped table '#{name}'".red)

        _.each cols, (col) -> console.log("  #{col}")
        
        resolve()

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

  setupPg: setupPg = (db) ->
    client = new postgres.Client("tcp://#{config.pg.host}/#{db || config.pg.db}")
    client.connect()
    client
    
  setupRedis: ->
    require('redis').createClient(config.redis.port, config.redis.host)

  when: Q.fcall

pg  = null
pg2 = setupPg('postgres')

module.exports = functions