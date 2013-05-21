# Ensure filenames are using the name defined in package.json.
# https://github.com/jdavis/grunt-rename

module.exports = (grunt) ->

  grunt.config.data.rename =
    node_template:
      src : "src/node-template.coffee"
      dest: "src/<%= pkg.name %>.coffee"
    node_template_bin:
      src : "bin/node-template"
      dest: "bin/<%= pkg.name %>"
    node_template_dir:
      src : "src/node-template"
      dest: "src/<%= pkg.name %>"

  grunt.loadNpmTasks "grunt-rename"