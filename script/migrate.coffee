# Common

require('../lib/common')(this)

# Migrate direction

process.env.MIGRATE = migrate = process.argv[2] || 'up'

# Run migrations

@createDatabase().then(
  =>
    migrations = [
      =>
        @createTable(
          "models"
          [ "name VARCHAR(128)" ]
        )
      =>
        @addColumns(
          "models"
          [ "test VARCHAR(128)" ]
        )
    ]

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