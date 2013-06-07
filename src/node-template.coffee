for key, value of require('./node-template/common')
  eval("var #{key} = value;")

module.exports = class NodeTemplate
  constructor: ->
    AWS.config.loadFromPath(path.resolve(__dirname, "../config/aws.json"))
    @db = new AWS.DynamoDB()