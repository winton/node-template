for key, value of require('./node-template/common')
  eval("var #{key} = value;")

module.exports = class NodeTemplate
  constructor: ->

NodeTemplate.Cluster = require("./node-template/cluster")