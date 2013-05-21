# Compile coffeescripts to lib directory.
# https://github.com/gruntjs/grunt-contrib-coffee

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