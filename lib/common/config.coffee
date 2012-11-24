fs = require('fs')

config = process.env.NODE_ENV || 'development'
config = fs.readFileSync("#{__dirname}/../../config/#{config}.json")
config = JSON.parse(config)

module.exports = config