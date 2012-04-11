exec = require('child_process').exec
fs   = require('fs')

# Helpers

ask = (q, fn) ->
  console.log("\n\033[1;33m#{q}\033[0m")
  process.stdin.resume();
  process.stdin.setEncoding('utf8');
  process.stdin.on 'data', (path) ->
    console.log('')
    fn(path.replace(/\s+$/, ''))

replaceProcess = (cmd) -> 
  kexec = require('kexec')
  kexec("cd #{__dirname} && #{cmd}")

# Tasks

task 'bootstrap', 'update bootstrap', (options) ->
  console.log [
    "\n\033[1;31mIf you haven't already:\033[0m"
    "\n  git clone git://github.com/twitter/bootstrap.git"
    "\n  Modify less/bootstrap.less to customize package."
  ].join("\n")
  ask 'Where is your bootstrap clone?', (path) ->
    replaceProcess("bin/client.sh bootstrap '#{path}'")

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
      replaceProcess("bin/client.sh new '#{name}' '#{url}'")
    else
      console.log('Unrecognized Github repo SSH URL.')

task 'start', 'start node', (options) ->
  replaceProcess("foreman start")

task 'test', 'run tests', (options) ->
  replaceProcess("mocha test/test.js --reporter spec")