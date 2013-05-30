# Update package.json and rename project.

path = require("path")
fs   = require("fs")

Coffee = require("coffee-script")
prompt = require("prompt")

prompt.message   = ""
prompt.delimiter = ""

module.exports = (grunt) ->

  grunt.registerTask("setup:bin", "Rewrite the bin file.", ->
    fs.writeFileSync(
      path.resolve(__dirname, "../bin/#{grunt.config("pkg").name}")
      "#!/usr/bin/env node\n" + Coffee.compile(
        """
        NodeTemplate = require("../lib/node-template")
        new NodeTemplate
        """
      )
    )
  )

  grunt.registerTask("setup:branch", "Choose a template branch.", ->
    done = @async()

    prompt.start()
    prompt.get(
      properties:
        branch:
          default    : "master"
          description: "node-template branch?"
          pattern    : /^[a-zA-Z\-\_\d]+$/
          message    : 'Name must be only letters, numbers, underscores, or dashes'
          required   : true
      (err, result) =>
        grunt.util.spawn(
          cmd : "git"
          args: [ "fetch", "origin" ]
          opts: stdio: "inherit"
          ->
            grunt.util.spawn(
              cmd : "git"
              args: [ "pull", "origin", result.branch ]
              opts: stdio: "inherit"
              (error, result, code) ->
                done()
            )
        )
    )
  )

  grunt.registerTask("setup:remote", "Set the git origin to the same as the repo listed in package.json.", ->
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
      'setup:remote'
      'rename'
      'setup:bin'
      'replace'
      'coffee'
    ]
  )