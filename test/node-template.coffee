{ exec } = require "child_process"
fs = require "fs"

template = require "../lib/node-template.js"
Bin = require "../bin/node-template.coffee"

describe "NodeTemplate", ->
  describe "bin", ->
    question = null

    before (done) ->
      @timeout(0)
      process.argv = [ null, null, "test/fixture" ]
      exec "rm -rf test/fixture", ->
        new Bin
          ask: (q, fn) ->
            question = q
            fn('user')
          done: done

    it "should ask for a Github username", ->
      question.should.equal("What is your Github username?")

    it "should clone github repo", ->
      stats = fs.lstatSync("#{__dirname}/fixture")
      stats.isDirectory().should.equal(true)

    it "should update remote origin", ->
      config = fs.readFileSync "#{__dirname}/fixture/.git/config"
      config
        .toString()
        .indexOf("github.com:user/fixture.git")
        .should.not.equal(-1)

    it "should run cake install", ->
      stats = fs.lstatSync("#{__dirname}/fixture/node_modules")
      stats.isDirectory().should.equal(true)
      stats = fs.lstatSync("#{__dirname}/fixture/npm-shrinkwrap.json")
      stats.isFile().should.equal(true)