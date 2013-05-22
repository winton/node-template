# Update package.json and rename project.

path = require("path")
fs   = require("fs")

module.exports = (grunt) ->

  grunt.registerTask("setup:bin", "Rewrite the bin file.", ->
    fs.writeFileSync(
      path.resolve(__dirname, "../bin/#{grunt.config("pkg").name}")
      """
      #!/usr/bin/env coffee

      NodeTemplate = require("../lib/node-template")
      """
    )
  )

  grunt.registerTask("setup:git", "Set the git origin to the same as package.json.", ->
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