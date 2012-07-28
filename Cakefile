exec = require('child_process').exec
fs   = require('fs')

# Helpers

ask = (q, fn) ->
  console.log("\n\x1B[1;33m#{q}\x1B[0m")
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
  exec 'npm link', ->
    console.log('Installed npm packages.')

task 'new', 'create a new project', (options) ->
  ask 'Github repo SSH URL?', (url) ->
    url = url.match(/.+@github.com:.+\/(.+)\.git/)
    if url
      [ url, name ] = url
      replaceProcess("script/new '#{name}' '#{url}'")
    else
      console.log('Unrecognized Github repo SSH URL.')

task 'test', 'run tests', (options) ->
  replaceProcess("mocha test/test.js --reporter spec")