# usage: log('inside coolFunc', this, arguments);

window.log = f = ->
  log.history = log.history or []
  log.history.push arguments
  if @console
    args = arguments
    newarr = undefined
    args.callee = args.callee.caller
    newarr = [].slice.call(args)
    if typeof console.log is "object"
      log.apply.call console.log, console, newarr
    else
      console.log.apply console, newarr

# make it safe to use console.log always

((a) ->
  b = ->
  c = "assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(",")
  d = undefined

  while !!(d = c.pop())
    a[d] = a[d] or b
)(
  ->
    try
      console.log()
      return window.console
    catch a
      return (window.console = {})
)