for key, value of require('./node-template/common')
  eval("var #{key} = value;")

module.exports = class NodeTemplate
  initialize: =>