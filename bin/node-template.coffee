{ exec } = require "child_process"
path = require "path"

require "colors"
glob = require "glob"
_ = require "underscore"

module.exports = class Bin
  constructor: (options={}) ->

    names = process.argv.splice(2)

    if names.length
      
      ask = options.ask || @ask

      ask "What is your Github username?", (login) =>
        _.each names, (name) =>

          commands = []
          dir = null

          if name.indexOf('/') > -1
            dir = path.dirname(name)
            name = path.basename(name)

          if dir
            commands = commands.concat [
              "mkdir -p #{dir}"
              "cd #{dir}"
            ]

          commands = commands.concat [
            "git clone git://github.com/winton/node-template.git #{name}"
            "cd #{name}"
            "git remote rm origin"
            "git remote add origin git@github.com:#{login}/#{name}.git"
            "rm npm-shrinkwrap.json"
            "npm install"
            "rm bin/node-template.coffee"
            "rm test/node-template.coffee"
          ]

          # Overwrite files to remove node-template code

          @overwrite =
            "bin/node-template": """
              #!/usr/bin/env node

              require("../lib/#{name}");
              """
            "src/node-template.coffee": """
              common = require './#{name}/common'
              async  = common.async
              _  = common.underscore
              """
          
          _.each @overwrite, (body, path) ->
            body = body.replace(/\n/g, "\\n").replace(/"/g, "\\\"")
            commands.push "echo \"#{body}\" > #{path}"

          @executing(commands)
          
          exec commands.join(' && '), @catchError =>

            dir = if dir then "#{dir}/" else ""
            cwd = process.cwd()

            commands = []

            glob "#{dir}#{name}/**/node-template*", (e, paths) =>
              _.each paths, (path) ->
                commands.push "mv #{path} #{Bin.renamePath(path, name)}"

              commands = commands.concat [
                "cd #{dir}#{name}"
                "coffee -o lib -c src"
                "cd #{cwd}"
              ]

              @executing(commands)

              exec commands.join(' && '), @catchError ->
                if options.done then options.done() else process.exit()

  ask: (q, fn) ->
    console.log "\n#{q}".bold.yellow
    process.stdin.resume()
    process.stdin.setEncoding "utf8"
    process.stdin.on "data", (path) ->
      fn path.replace(/\s+$/, "")

  catchError: (successFn) ->
    (error, stdout, stderr) ->
      if error
        console.log "\nError :(".bold.red
        console.log stderr
      else
        console.log "\nSuccess :)\n".bold.green
        successFn(error, stdout, stderr) if successFn

  executing: (commands) ->
    console.log "\nExecuting:".bold.yellow
    _.each commands, (command) -> console.log(command)

  @renamePath: (p, new_name) ->
    base = path.basename(p)
    dir = path.dirname(p)
    "#{dir}/#{base.replace('node-template', new_name)}"