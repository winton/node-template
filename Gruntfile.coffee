prompt = require "prompt"
prompt.message   = ""
prompt.delimiter = ""

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

  grunt.registerTask 'default',        [ 'watch' ]
  grunt.registerTask 'rename_project', [ 'replace', 'rename' ]

  grunt.registerTask 'setup', 'Setup a new project.', ->
    done = @async()

    schema =
      properties:
        name:
          default    : grunt.option('name')
          description: "Project name?"
          pattern    : /^[a-zA-Z\-\_\d]+$/
          message    : 'Name must be only letters, numbers, underscores, or dashes'
          required   : true
        version:
          default    : grunt.option('version') || "0.1.0"
          description: "Version?"
          pattern    : /^[a-zA-Z\d\.]+$/
          message    : 'Version must be only numbers, letters, or periods'
          required   : true
        author:
          default    : grunt.option('author')
          description: "Author?"
          required   : true
        repo:
          default    : grunt.option('repo')
          description: "Repository URL?"
          required   : true

    prompt.override =
      name   : grunt.option('name')
      version: grunt.option('version')
      author : grunt.option('author')
      repo   : grunt.option('repo')

    prompt.start()
    prompt.get schema, (err, result) ->
      console.log(result)
      done()
