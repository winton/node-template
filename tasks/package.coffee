# Prompt user for package.json information and rewrite it.
# https://github.com/nodejitsu/node-prompt

fs     = require "fs"
path   = require "path"
prompt = require "prompt"

prompt.message   = ""
prompt.delimiter = ""

module.exports = (grunt) ->
  
  grunt.registerTask('package', 'Update package.json.', ->
    done = @async()

    prompts =
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

    prompt.get prompts, (err, result) =>
      pkg  = grunt.config('pkg')
      pkg.repository.url = result.repo

      delete result.repo

      pkg = grunt.util._.extend(pkg, result)
      grunt.config('pkg', pkg)

      json = JSON.stringify(pkg, null, 4)
      
      fs.writeFileSync(
        path.resolve(__dirname, 'package.json')
        json
      )

      done()
  )