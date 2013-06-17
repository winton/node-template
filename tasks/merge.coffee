# Merges git branches.
# https://github.com/winton/grunt-merge

path = require "path"

module.exports = (grunt) ->

  grunt.config.data.merge =
    'aws'              : [ 'master' ]
    'aws-dynamo'       : [ 'aws' ]
    'bookshelf'        : [ 'master' ]
    'bookshelf-express': [ 'bookshelf', 'express' ]
    'express'          : [ 'master' ]

  grunt.task.loadTasks path.resolve(__dirname, "../node_modules/grunt-merge/lib")