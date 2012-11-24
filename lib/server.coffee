node_env = process.env.NODE_ENV ||= 'development'
port     = process.env.PORT     ||= if node_env == 'development' then 8080 else 80

app     = require('./app.coffee')
cluster = require('cluster')
cpus    = require('os').cpus().length

if node_env == 'development'
  app.listen port
  console.log "Node.js started on port #{port}"
else
  if cluster.isMaster
    cluster.fork() for x in [1..cpus]

    cluster.on 'exit', (worker, code, signal) ->
      console.log "Worker ##{worker.process.pid} died"
      cluster.fork()
  else
    app.listen port
  
  console.log "Node.js cluster started on port #{port}"