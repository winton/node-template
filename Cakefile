_ = require "underscore"
glob = require "glob"
path = require "path"
{spawn} = require "child_process"

task 'rename', 'rename the project', (options) ->
  glob "**/node_template*", options, (e, paths) ->
    name = path.basename(__dirname)
    _.each paths, (path) ->
      spawn "mv", [ path, path.replace('node_template', name) ]