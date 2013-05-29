# Continuously rewrite lib directory as coffee files change.
# https://github.com/gruntjs/grunt-contrib-watch

module.exports = (grunt) ->

  grunt.config.data.watch =
    scripts:
      files  : [ '**/*.coffee' ],
      tasks  : [ 'coffee' ],
      options: nospawn: true

  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.registerTask "default", [ "coffee:clean", "coffee", "watch" ]