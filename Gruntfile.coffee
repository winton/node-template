module.exports = (grunt) ->

  grunt.toCamel = (str) ->
    str.replace /((^|\-)[a-z])/g, ($1) -> $1.toUpperCase().replace('-','')

  grunt.initConfig
    coffee:
      glob_to_multiple:
        options: sourceMap: true
        expand : true
        cwd    : 'src'
        src    : '**/*.coffee'
        dest   : 'lib'
        ext    : '.js'

    pkg: grunt.file.readJSON("package.json")

    rename:
      node_template:
        src : "src/node-template.coffee"
        dest: "src/<%= pkg.name %>.coffee"
      node_template_bin:
        src : "bin/node-template"
        dest: "bin/<%= pkg.name %>"
      node_template_dir:
        src : "src/node-template"
        dest: "src/<%= pkg.name %>"

    replace:
      node_template:
        overwrite   : true
        replacements: [ from: /node-template/g, to: "<%= pkg.name %>" ]
        src         : replace_paths = [
          "bin/*"
          "Gruntfile.coffee"
          "package.json"
          "src/**/*.coffee"
          "test/**/*.coffee"
        ]
      NodeTemplate:
        overwrite   : true
        replacements: [ from: /NodeTemplate/g, to: "<%= grunt.toCamel(pkg.name) %>" ]
        src         : replace_paths

    watch:
      scripts:
        files  : [ '**/*.coffee' ],
        tasks  : [ 'coffee' ],
        options: nospawn: true

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-release"
  grunt.loadNpmTasks "grunt-rename"
  grunt.loadNpmTasks "grunt-text-replace"

  grunt.registerTask 'default',  [ 'watch' ]
  grunt.registerTask 'rename_project', [ 'replace', 'rename' ]