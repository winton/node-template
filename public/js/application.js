(function() {
  var f;

  window.log = f = function() {
    var args, newarr;
    log.history = log.history || [];
    log.history.push(arguments);
    if (this.console) {
      args = arguments;
      newarr = void 0;
      args.callee = args.callee.caller;
      newarr = [].slice.call(args);
      if (typeof console.log === "object") {
        return log.apply.call(console.log, console, newarr);
      } else {
        return console.log.apply(console, newarr);
      }
    }
  };

  (function(a) {
    var b, c, d, _results;
    b = function() {};
    c = "assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(",");
    d = void 0;
    _results = [];
    while (!!(d = c.pop())) {
      _results.push(a[d] = a[d] || b);
    }
    return _results;
  })(function() {
    try {
      console.log();
      return window.console;
    } catch (a) {
      return (window.console = {});
    }
  });

}).call(this);
