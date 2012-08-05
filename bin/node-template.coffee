{ exec } = require "child_process"
path = require "path"

require "colors"
glob = require "glob"
_ = require "underscore"

module.exports = class
  constructor: (options) ->

    # Helper methods

    ask = options.ask || (q, fn) ->
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

          dir = null

          if name.indexOf('/') > -1
            dir = path.dirname(name)
            name = path.basename(name)

          commands = [
            "git clone git://github.com/winton/node-template.git #{name}"
            "cd #{name}"
            "git remote rm origin"
            "git remote add origin git@github.com:#{login}/#{name}.git"
            "cake install"
            "rm bin/node-template.coffee"
          ]

          if dir
            commands.unshift("mkdir -p #{dir}")
            commands.unshift("cd #{dir}")

          console.log(commands)
          
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

            if options.done then options.done() else process.exit()