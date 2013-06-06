for key, value of require("../lib/node-template/common")
  eval("var #{key} = value;")

NodeTemplate = require("../lib/node-template")
bookshelf    = NodeTemplate.loadBookshelf()

exports.up = (next) ->
  bookshelf.spread((db) ->
    db.Knex.Schema.createTable("users", (table) ->
      table.string "login"
      table.timestamps()
    )
  ).then ->
    console.log "  -> users table created"
    next()

exports.down = (next) ->
  bookshelf.spread((db) ->
    db.Knex.Schema.dropTable("users")
  ).then ->
    console.log "  -> users table dropped"
    next()