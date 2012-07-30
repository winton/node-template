common = require "../lib/node_template/common"
_ = common.underscore
{ exec } = require "child_process"

# Helper methods

ask = (q, fn) ->
  console.log yellow("\n#{q}")
  process.stdin.resume()
  process.stdin.setEncoding "utf8"
  process.stdin.on "data", (path) ->
    fn path.replace(/\s+$/, "")

green = (str) -> "\u001b[1;32m#{str}\u001b[0m"
red = (str) -> "\u001b[1;31m#{str}\u001b[0m"
yellow = (str) -> "\u001b[1;33m#{str}\u001b[0m"

# Overwrite files to remove node_template code

overwrite =
  "bin/node_template": """
    #!/usr/bin/env node

    require("../lib/node_template");
    """

# Create projects

names = process.argv.splice(2)

if names.length
  ask "What is your Github username?", (login) ->
    _.each names, (name) ->
      commands = [
        "git clone git://github.com/winton/node_template.git #{name}"
        "cd #{name}"
        "git remote rm origin"
        "git remote add origin git@github.com:#{login}/#{name}.git"
        "npm install"
        "rm bin/node_template.coffee"
      ]
      
      _.each overwrite, (body, path) ->
        body = body.replace(/\n/g, "\\n").replace(/"/g, "\\\"")
        commands.push "echo \"#{body}\" > #{path}"

      console.log yellow("\nExecuting:")
      _.each commands, (command) -> console.log(command)
      
      exec commands.join(' && '), (error, stdout, stderr) ->
        if error
          console.log red("\nError :(")
          console.log stderr
        else
          console.log green("\nSuccess :)\n")
        process.exit()