var Backbone, app, async, common, connect_redis, customSession, express, node_env, redis, secret, session, _;

node_env = process.env.NODE_ENV || 'development';

common = require('./common');

async = common.async;

Backbone = common.Backbone;

redis = common.redis;

secret = common.secret;

_ = common.Underscore;

express = require('express');

app = module.exports = express.createServer();

connect_redis = require('connect-redis')(express);

session = express.session({
  cookie: {
    path: '/',
    httpOnly: true,
    maxAge: 365 * 24 * 60 * 60 * 1000
  },
  secret: secret,
  store: new connect_redis
});

customSession = function(req, res, next) {
  if (req.param('session') === '0') {
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
  return app.use(customSession);
});

Backbone.sync = function(method, model, options) {
  var id, path, r, success;
  path = _.isFunction(model.url) ? model.url() : model.url;
  if (model.models == null) {
    id = path.match(r = /\/([^\/]+)$/)[1];
    path = path.replace(r, '');
  }
  success = options.success;
  switch (method) {
    case "create":
    case "update":
      return redis.hset(path, id, JSON.stringify(model), function() {
        if (options.scope) {
          return redis.sadd(options.scope, path, function() {
            return success();
          });
        } else {
          return success();
        }
      });
    case "read":
      if (id) {
        return redis.hget(path, id, function(e, json) {
          return success(JSON.parse(json));
        });
      } else if (options.scope) {
        return redis.smembers(path, function(e, keys) {
          var fns;
          fns = _.map(keys, function(key) {
            return function(callback) {
              return redis.hgetall(key, function(e, hash) {
                return callback(null, _.map(_.values(hash), function(json) {
                  return JSON.parse(json);
                }));
              });
            };
          });
          return async.parallel(fns, function(err, results) {
            return success(_.flatten(results));
          });
        });
      } else {
        return redis.hgetall(path, function(e, hash) {
          return success(_.map(_.values(hash), function(json) {
            return JSON.parse(json);
          }));
        });
      }
      break;
    case "delete":
      return redis.hdel(path, id, function() {
        if (options.scope) {
          return redis.hlen(path, function(e, len) {
            if (len === 0) {
              return redis.srem(options.scope, path, function() {
                return success();
              });
            }
          });
        } else {
          return success();
        }
      });
  }
};

app.get('/test', function(req, res) {
  return res.send({
    test: 1
  });
});

if (!module.parent) {
  app.listen(8080);
  console.log('Node.js started on port 8080');
}
