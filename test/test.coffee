require("chai").should()

glob = require "glob"
_    = require "underscore"

describe "Setup", ->
  before (done) ->
    glob "#{__dirname}/**/*.coffee", (e, paths) ->
      _.each paths, (path) ->
        require(path)  if path.indexOf('/fixture/') == -1
      done()

  it "should setup", -> true.should.equal(true)