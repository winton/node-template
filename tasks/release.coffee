# Packages project for release.
# https://github.com/geddski/grunt-release

module.exports = (grunt) ->

  grunt.loadNpmTasks "grunt-release"
  grunt.task.renameTask "release", "release:publish"
  grunt.task.registerTask "release", [ "coffee", "release:publish" ]