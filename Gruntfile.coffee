module.exports = (grunt) ->

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

    # OK to remove after first use
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

    # OK to remove after first use
    replace:
      node_template:
        src         : [ "**/*.coffee", "bin/node-template" ]
        overwrite   : true
        replacements: [
          from: /[Nn]ode_?[Tt]emplate/g
          to  : "<%= pkg.name %>"
        ]

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

  grunt.registerTask 'default', [ 'watch' ]