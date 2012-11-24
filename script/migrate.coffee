# Common

common = require('./common')
eval("#{key} = value") for key, value of common

# Objects

pg  = common.setupPg()
pg2 = common.setupPg()

# Functions

migrateTable = (name, cols) ->
  cmd = process.argv[2] || 'up'

  promise (resolve, reject) ->
    if cmd == 'up'
      sql = "CREATE TABLE #{name} (id SERIAL, #{cols.join(", ")});"
    else if cmd == 'down'
      sql = "DROP TABLE IF EXISTS #{name};"
    
    pg.query sql, (err, result) ->
      console.log("Migrated #{name} #{cmd}")
      resolve()

# Runtime

pg2.query "CREATE DATABASE #{config.pg.db};", (err, result) ->
  migrateTable(
    "models"
    [ "name VARCHAR(128)" ]
  ).then(
    -> process.exit()
  )