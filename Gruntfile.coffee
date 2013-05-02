module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    coffee:
      glob_to_multiple:
        options: { sourceMap: true, join: true }
        expand : true
        cwd    : 'src'
        src    : '**/*.coffee'
        dest   : 'lib'
        ext    : '.js'

    rename:
      node_template:
        src : "src/node-template.coffee"
        dest: "src/<%= pkg.name %>.coffee"
      node_template_dir:
        src : "src/node-template"
        dest: "src/<%= pkg.name %>"

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-release"
  grunt.loadNpmTasks "grunt-rename"