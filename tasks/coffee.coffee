# Compile coffeescripts to lib directory.
# https://github.com/gruntjs/grunt-contrib-coffee

path = require("path")

module.exports = (grunt) ->

  grunt.config.data.coffee =
    glob_to_multiple:
      options: sourceMap: true
      expand : true
      cwd    : 'src'
      src    : '**/*.coffee'
      dest   : 'lib'
      ext    : '.js'

  grunt.loadNpmTasks "grunt-contrib-coffee"

  grunt.registerTask("coffee:clean", "Clean the lib directory.", ->
    done = @async()
    
    grunt.util.spawn(
      cmd : "rm"
      args: [ "-rf", path.resolve(__dirname, "../lib") ]
      opts: stdio: "inherit"
      (error, result, code) ->
        done()
    )
  )