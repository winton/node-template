(function() {
  var common;

  common = {
    EventEmitter: require('events').EventEmitter,
    Q: require('q'),
    _: require('underscore')
  };

  common.defer = function(fn) {
    var d;

    d = common.Q.defer();
    fn(d.resolve, d.reject);
    return d.promise;
  };

  module.exports = common;

}).call(this);

/*
//@ sourceMappingURL=common.js.map
*/