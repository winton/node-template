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
          cmd: [
            "git remote rm origin"
            "git remote add origin #{grunt.config('pkg').repository.url}"
          ].join(';')
          (error, result, code) ->
            console.log(error)
            console.log(String(result))
            console.log(code)
            done()
        )
      when 'bin'
        grunt.log.writeln(this.target + ': ' + this.data)
        done()
  )