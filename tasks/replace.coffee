# Ensure file contents are using the name defined in package.json.
# https://github.com/yoniholmes/grunt-text-replace

module.exports = (grunt) ->

  grunt.util.toCamel = (str) ->
    str.replace /((^|\-)[a-z])/g, ($1) -> $1.toUpperCase().replace('-','')

  grunt.config.data.replace =
    node_template:
      overwrite   : true
      replacements: [ from: /node-template/g, to: "<%= pkg.name %>" ]
      src         : replace_paths = [
        "bin/*"
        "Gruntfile.coffee"
        "package.json"
        "src/**/*.coffee"
        "tasks/**/*.coffee"
        "test/**/*.coffee"
      ]
    NodeTemplate:
      overwrite   : true
      replacements: [ from: /NodeTemplate/g, to: "<%= grunt.util.toCamel(pkg.name) %>" ]
      src         : replace_paths

  grunt.loadNpmTasks "grunt-text-replace"