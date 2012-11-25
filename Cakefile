{ exec } = require "child_process"
fs = require "fs"
path = require "path"

require "colors"
_ = require "underscore"

ask = (q, fn) ->
  console.log("\n#{q}".bold.yellow)
  process.stdin.resume();
  process.stdin.setEncoding('utf8');
  process.stdin.on 'data', (path) ->
    console.log('')
    fn(path.replace(/\s+$/, ''))

catchError = (successFn) ->
  (error, stdout, stderr) ->
    if error
      console.log "\nError :(".bold.red
      console.log stderr
    else
      console.log "\nSuccess :)\n".bold.green
      if successFn
        successFn(error, stdout, stderr)
      else
        process.exit()

executing = (commands) ->
  console.log "\nExecuting:".bold.yellow
  _.each commands, (command) -> console.log(command)

task 'bootstrap', 'upgrade bootstrap', ->
  console.log [
    "\nIf you haven't already:".bold.yellow
    "\n  git clone git://github.com/twitter/bootstrap.git"
    "\n  Modify less/bootstrap.less to customize package."
  ].join("\n")

  ask 'Where is your bootstrap clone?', (path) ->
    
    commands = [
      "rm -rf client/img/lib/bootstrap"
      "rm -rf client/js/lib/bootstrap"

      "mkdir -p client/img/lib/bootstrap"
      "mkdir -p client/js/lib/bootstrap"

      "cd #{path}"
      "make bootstrap"

      "cd #{process.cwd()}"
      "cp -f #{path}/bootstrap/css/bootstrap.css client/css/lib"
      "cp -f #{path}/bootstrap/css/bootstrap-responsive.css client/css/lib"
      "cp -f #{path}/js/*.js client/js/lib/bootstrap"
      "cp -f #{path}/img/*.png client/img/lib/bootstrap"
    ]

    executing(commands)
    exec commands.join(" && "), catchError()

task 'install', 'install shrinkwrapped and/or new dependencies', ->
  commands = [
    "rm -rf node_modules"
    "npm install"
    "rm -f npm-shrinkwrap.json"
    "npm install"
    "npm shrinkwrap"
  ]
  executing(commands)
  exec commands.join(" && "), catchError()

task 'publish', 'publish package to NPM', ->
  package_json = JSON.parse(fs.readFileSync("./package.json"))

  # Make sure repo is clean
  exec "git diff --exit-code", (error, stdout, stderr) ->
    if error
      console.log "\nThere are files that need to be committed first. :(\n".bold.red
    else

      # Make sure tag doesn't exist
      exec "git tag", (error, stdout, stderr) ->
        if stdout.split(/\n/).indexOf(package_json.version) > -1
          console.log "\nThis tag (v#{package_json.version}) has already been committed to the repo. :(\n".bold.red
        else

          # Generate commands to move dev dependencies into ./tmp
          commands = _.compact _.map package_json.devDependencies, (version, pkg) ->
            if fs.existsSync("node_modules/#{pkg}")
              "mv -f node_modules/#{pkg} tmp/#{pkg}"
          commands.unshift "mkdir -p tmp"

          # Move ./npm-shrinkwrap.json into ./tmp
          if fs.existsSync("npm-shrinkwrap.json")
            commands.push "mv -f npm-shrinkwrap.json tmp/npm-shrinkwrap.json"

          # Shrinkwrap at the end
          commands.push "npm shrinkwrap"

          # Commit production shrinkwrap
          commands.push "git add npm-shrinkwrap.json"
          commands.push "git commit -m 'Freezing production shrinkwrap for v#{package_json.version}'"

          # Execute commands
          executing(commands)
          exec commands.join(' && '), catchError ->

            # Create tag
            console.log "Tagging v#{package_json.version}...".bold.yellow
            exec "git tag -a -m \"Version #{package_json.version}\" v#{package_json.version}", catchError (error, stdout, stderr) ->

              # Generate commands to move dev dependencies back into ./node_modules
              commands = _.compact _.map package_json.devDependencies, (version, pkg) ->
                if fs.existsSync("tmp/#{pkg}")
                  "mv -f tmp/#{pkg} node_modules/#{pkg}"

              # Move ./tmp/npm-shrinkwrap.json to ./npm-shrinkwrap.json
              if fs.existsSync("tmp/npm-shrinkwrap.json")
                commands.push "mv -f tmp/npm-shrinkwrap.json npm-shrinkwrap.json"

              # Execute commands
              executing(commands)
              exec commands.join(' && '), catchError ->

                # Push repo and tags
                console.log "Pushing shrinkwrap commit and tags...".bold.yellow
                exec "git push && git push --tags", catchError ->

                  # Publish
                  commands = [ "npm publish" ]
                  executing(commands)
                  exec commands.join(' && '), catchError