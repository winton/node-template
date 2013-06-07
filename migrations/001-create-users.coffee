for key, value of require("../lib/node-template/common")
  eval("var #{key} = value;")

NodeTemplate = require("../lib/node-template")
node_template = new NodeTemplate

exports.up = (next) ->
  node_template.db.createTable(
    TableName: "Users"
    AttributeDefinitions: [
      {
        AttributeName: "Id",
        AttributeType: "N"
      }
    ]
    KeySchema: [
      {
        AttributeName: "Id",
        KeyType: "HASH"
      }
    ]
    # LocalSecondaryIndexes: []
    ProvisionedThroughput:
      ReadCapacityUnits: 1,
      WriteCapacityUnits: 1
    (e, data) ->
      if e
        console.log(e)
      else
        console.log(data)
        next()
  )

exports.down = (next) ->
  node_template.db.deleteTable(
    TableName: "Users"
    (e, data) ->
      if e
        console.log(e)
      else
        console.log(data)
        next()
  )