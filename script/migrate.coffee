# Common

require('../lib/common')(this)

# Migrations

migrations = [
  =>
    createTable(
      "models"
      [ "name VARCHAR(128)" ]
    )
  =>
    addColumns(
      "models"
      [ "test VARCHAR(128)" ]
    )
]

# Migrate direction

process.env.MIGRATE = migrate = process.argv[2] || 'up'

# Functions

addColumns = (name, cols) =>
  action  = if migrate == 'up' then 'ADD' else 'DROP'

  columns = @_.map(
    cols
    (col) -> "#{action} COLUMN #{
      if migrate == 'up' then col else col.split(' ')[0]
    }"
  ).join(', ')

  sql = "ALTER TABLE #{name} #{columns};"

  @query(sql).then(
    =>
      if migrate == 'up'
        console.log("\nAdded columns to table '#{name}'".green)
      else if migrate == 'down'
        console.log("\nDropped columns from table '#{name}'".red)

      @_.each cols, (col) -> console.log("  #{col}")
    (e) =>
      console.log("\n#{e}".red)
      console.log("  #{sql}")
  )

createDatabase = (name) =>
  @query("CREATE DATABASE #{name || @config.pg.db};", @setupPg('postgres'))
    .fail(->)
    .fin(
      => @pg = @setupPg()
    )

createTable = (name, cols) =>
  if migrate == 'up'
    sql = "CREATE TABLE #{name} (id SERIAL, #{cols.join(", ")});"
  else if migrate == 'down'
    sql = "DROP TABLE #{name};"

  @query(sql).then(
    =>
      if migrate == 'up'
        console.log("\nCreated table '#{name}'".green)
      else if migrate == 'down'
        console.log("\nDropped table '#{name}'".red)

      @_.each cols, (col) -> console.log("  #{col}")
    (e) =>
      console.log("\n#{e}".red)
      console.log("  #{sql}")
  )

# Run migrations

createDatabase().then(
  => 
    if migrate == 'down'
      migrations = migrations.reverse()

    run = @Q.resolve()

    @_.each migrations, (fn) ->
      run = run.then(fn)

    run
).then(
  =>
    console.log("")
    process.exit()
).done()