{ exec } = require "child_process"

require "colors"

common = require "../lib/node-template/common"
_ = common.underscore

# Helper methods

ask = (q, fn) ->
  console.log "\n#{q}".bold.yellow
  process.stdin.resume()
  process.stdin.setEncoding "utf8"
  process.stdin.on "data", (path) ->
    fn path.replace(/\s+$/, "")

# Overwrite files to remove node-template code

overwrite =
  "bin/node-template": """
    #!/usr/bin/env node

    require("../lib/node-template");
    """

# Create projects

names = process.argv.splice(2)

if names.length
  ask "What is your Github username?", (login) ->
    _.each names, (name) ->
      commands = [
        "git clone git://github.com/winton/node-template.git #{name}"
        "cd #{name}"
        "git remote rm origin"
        "git remote add origin git@github.com:#{login}/#{name}.git"
        "npm install"
        "rm bin/node-template.coffee"
      ]
      
      _.each overwrite, (body, path) ->
        body = body.replace(/\n/g, "\\n").replace(/"/g, "\\\"")
        commands.push "echo \"#{body}\" > #{path}"

      console.log "\nExecuting:".bold.yellow
      _.each commands, (command) -> console.log(command)
      
      exec commands.join(' && '), (error, stdout, stderr) ->
        if error
          console.log "\nError :(".bold.red
          console.log stderr
        else
          console.log "\nSuccess :)\n".bold.green

        glob "#{name}/**/node-template*", options, (e, paths) ->
          name = path.basename(__dirname)
          _.each paths, (path) ->
            spawn "mv", [ path, path.replace('node-template', name) ]

        process.exit()