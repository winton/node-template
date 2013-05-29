# Update package.json and rename project.

path = require("path")
fs   = require("fs")

Coffee = require("coffee-script")

module.exports = (grunt) ->

  grunt.registerTask("setup:bin", "Rewrite the bin file.", ->
    fs.writeFileSync(
      path.resolve(__dirname, "../bin/#{grunt.config("pkg").name}")
      "#!/usr/bin/env node\n" + Coffee.compile(
        fs.readFileSync("#{__dirname}/templates/bin.coffee").toString()
      )
    )
  )

  grunt.registerTask("setup:git", "Set the git origin to the same as the repo listed in package.json.", ->
    done = @async()

    grunt.util.spawn(
      cmd : "git"
      args: [ "remote", "rm", "origin" ]
      opts: stdio: "inherit"
      (error, result, code) ->
        grunt.util.spawn(
          cmd: "git"
          args: [ "remote", "add", "origin", grunt.config("pkg").repository.url ]
          opts: stdio: "inherit"
          (error, result, code) -> done()
        )
    )
  )

  grunt.task.registerTask(
    'setup'
    [
      'package'
      'setup:git'
      'rename'
      'setup:bin'
      'replace'
    ]
  )