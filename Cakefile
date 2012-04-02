exec = require('child_process').exec
fs   = require('fs')

# Helpers

ask = (q, fn) ->
  console.log("\n#{q}")
  process.stdin.resume();
  process.stdin.setEncoding('utf8');
  process.stdin.on 'data', (path) ->
    console.log('')
    fn(path.replace(/\s+$/, ''))

replaceProcess = (cmd) -> 
  kexec = require('kexec')
  kexec("cd #{__dirname} && #{cmd}")

# Tasks

task 'install', 'install dependencies', (options) ->
  invoke('install:node')
  invoke('install:ruby')

task 'install:node', 'install node dependencies', (options) ->
  exec 'npm link', ->
    console.log('Installed npm packages.')

task 'install:ruby', 'install ruby dependencies', (options) ->
  exec 'gem install --no-ri --no-rdoc bundler', ->
    console.log('Installed bundler.')
    exec 'cd ' + __dirname + '/stasis && bundle install', ->
      console.log('Installed gems.')

task 'new', 'create a new project', (options) ->
  ask 'Github repo SSH URL?', (url) ->
    url = url.match(/.+@github.com:.+\/(.+)\.git/)
    if url
      [ url, name ] = url
      cmd = [
        "cd ../"
        "git init #{name}"
        "cd #{name}"
        "git remote add origin #{url}"
        "git remote add template git://github.com/winton/node_template.git"
        "git fetch template"
        "git merge template/master"
        "cake install"
        "echo \"\n\\033[1;32mSuccess!\\033[0m\n\""
        "echo \"\\033[1;33mStart your server:\\033[0m cd ../#{name} && cake start\n\""
      ].join(' && ')
      replaceProcess(cmd)
    else
      console.log('Unrecognized Github repo SSH URL.')

task 'start', 'start node', (options) ->
  replaceProcess("foreman start")

task 'test', 'run tests', (options) ->
  replaceProcess("mocha test/test.js --reporter spec")