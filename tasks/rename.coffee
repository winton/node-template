# Ensure filenames are using the name defined in package.json.
# https://github.com/jdavis/grunt-rename

module.exports = (grunt) ->

  grunt.config.data.rename =
    bin_path:
      src : "bin/node-template"
      dest: "bin/<%= pkg.name %>"
    src_path:
      src : "src/node-template.coffee"
      dest: "src/<%= pkg.name %>.coffee"

  grunt.loadNpmTasks "grunt-rename"