var app, async, common, config, crypto, express, node_env, port, secret, session, sessionGate, _;

node_env = process.env.NODE_ENV || 'development';

common = require('./common');

async = common.async;

config = common.config;

crypto = common.crypto;

secret = common.secret;

_ = common.underscore;

express = require('express');

app = module.exports = express.createServer();

session = express.session({
  cookie: {
    path: '/',
    httpOnly: true,
    maxAge: 365 * 24 * 60 * 60 * 1000
  },
  secret: secret
});

sessionGate = function(req, res, next) {
  var no_session;
  no_session = ["/hello.json"];
  if (no_session.indexOf(req.url.split('?')[0]) > -1) {
    return next();
  } else {
    return session(req, res, next);
  }
};

app.configure(function() {
  app.use(express.static("" + __dirname + "/../public"));
  app.set('views', "" + __dirname + "/views");
  app.use(express.bodyParser());
  app.use(express.cookieParser());
  app.use(express.logger());
  app.use(express.methodOverride());
  return app.use(sessionGate);
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
