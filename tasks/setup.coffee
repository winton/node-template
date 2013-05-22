# Update package.json and rename project.

module.exports = (grunt) ->

  grunt.config.data.setup =
    start: true
    bin : true
    git : true

  grunt.registerMultiTask("setup", "Setup your project.", ->
    done = @async()

    switch @target
      when 'start'
        grunt.task.run(
          "package"
          "replace"
          "rename"
        )
        done()
      when 'git'
        grunt.util.spawn(
          cmd : "git"
          args: [ "remote", "rm", "origin" ]
          opts: stdio: "inherit"
          (error, result, code) ->
            grunt.util.spawn(
              cmd: "git"
              args: [ "remote", "add", "origin", grunt.config("pkg").repository.url ]
              opts: stdio: "inherit"
              (error, result, code) ->
                done()
            )
        )
      when 'bin'
        grunt.log.writeln(this.target + ': ' + this.data)
        done()
  )