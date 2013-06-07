#!/usr/bin/env coffee

cluster = require("cluster")
cpus    = require("os").cpus().length

NodeTemplate = require("../lib/node-template")

node_env = process.env.NODE_ENV ||= 'development'

# Development
if node_env == 'development'
  new NodeTemplate(process.env.PORT ||= 8080)

# Master process
else if cluster.isMaster
  cluster.fork()  for i in [1..cpus]
  cluster.on "exit", (worker, code, signal) ->
    cluster.fork()

# Forked process
else
  new NodeTemplate(process.env.PORT ||= 80)