cluster = require("cluster")
cpus    = require("os").cpus().length

NodeTemplate = require("../node-template")

module.exports = class Cluster
  constructor: ->
    if cluster.isMaster
      cluster.fork()  for i in [1..cpus]
      cluster.on "exit", (worker, code, signal) ->
        cluster.fork()
    else
      new NodeTemplate()