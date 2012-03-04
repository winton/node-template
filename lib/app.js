var Backbone, app, async, common, config, crypto, express, fs, node_env, port, rest, secret, session, _;

node_env = process.env.NODE_ENV || 'development';

common = require('./common');

async = common.async;

Backbone = common.Backbone;

crypto = common.crypto;

rest = common.rest;

secret = common.secret;

_ = common.underscore;

express = require('express');

app = module.exports = express.createServer();

fs = require('fs');

config = "" + __dirname + "/../config/node_template.json";

config = JSON.parse(fs.readFileSync(config))[node_env];

session = express.session({
  cookie: {
    path: '/',
    httpOnly: true,
    maxAge: 365 * 24 * 60 * 60 * 1000
  },
  secret: secret
});

app.configure(function() {
  app.use(express.static("" + __dirname + "/../public"));
  app.set('views', "" + __dirname + "/views");
  app.use(express.bodyParser());
  app.use(express.cookieParser());
  app.use(express.logger());
  return app.use(express.methodOverride());
});

app.error(function(err, req, res, next) {
  var code;
  code = (Math.random() + '').substring(2);
  console.log("\nError - " + code + " - " + ((new Date()).toUTCString()));
  console.log("" + req.method + " " + req.url);
  console.log(req.query);
  if (req.headers['user-agent']) console.log("" + req.headers['user-agent']);
  console.log("\n" + err.stack + "\n");
  return res.send("Error reference code " + code);
});

app.get('/hello.json', session, function(req, res) {
  return res.send({
    hello: 'world'
  });
});

if (!module.parent) {
  port = node_env === 'production' ? 80 : 8080;
  if (process.env.PORT) port = process.env.PORT;
  app.listen(port);
  console.log("Node.js started on port " + port);
}
