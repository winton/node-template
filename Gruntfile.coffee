path = require "path"

module.exports = (grunt) ->
  grunt.config.data.pkg = grunt.file.readJSON("package.json")
  grunt.loadTasks(path.resolve(__dirname, 'tasks'))