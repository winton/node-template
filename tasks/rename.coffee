# Ensure filenames are using the name defined in package.json.
# https://github.com/jdavis/grunt-rename

module.exports = (grunt) ->

  grunt.config.data.rename =
    bin_path:
      src : "bin/node-template"
      dest: "bin/<%= pkg.name %>"
    src_directory:
      src : "src/node-template"
      dest: "src/<%= pkg.name %>"
    src_path:
      src : "src/node-template.coffee"
      dest: "src/<%= pkg.name %>.coffee"
    test_directory:
      src : "test/node-template"
      dest: "test/<%= pkg.name %>"
    test_path:
      src : "test/node-template.coffee"
      dest: "test/<%= pkg.name %>.coffee"

  grunt.loadNpmTasks "grunt-rename"