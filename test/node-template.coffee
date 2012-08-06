{ exec } = require "child_process"
fs = require "fs"

_ = require "underscore"

Bin = require "../bin/node-template.coffee"

describe "NodeTemplate", ->
  describe "bin", ->
    bin = null
    question = null

    before (done) ->
      @timeout(0)
      process.argv = [ null, null, "test/fixture" ]

      # I get "max depth reached" when depth = Infinity (npm bug)
      exec "npm config set depth 1000000 && rm -rf test/fixture", ->
        bin = new Bin
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
      stats = fs.statSync("#{__dirname}/fixture/node_modules")
      stats.isDirectory().should.equal(true)
      stats = fs.statSync("#{__dirname}/fixture/npm-shrinkwrap.json")
      stats.isFile().should.equal(true)

    it "should remove bin/node-template.coffee", ->
      exists = fs.existsSync("#{__dirname}/fixture/bin/node-template.coffee")
      exists.should.equal(false)
      exists = fs.existsSync("#{__dirname}/fixture/bin/fixture.coffee")
      exists.should.equal(false)

    it "should remove test/node-template.coffee", ->
      exists = fs.existsSync("#{__dirname}/fixture/test/node-template.coffee")
      exists.should.equal(false)
      exists = fs.existsSync("#{__dirname}/fixture/test/fixture.coffee")
      exists.should.equal(false)

    it "should overwrite certain files", ->
      _.each bin.overwrite, (body, path) ->
        body = "#{body}\n"
        path = Bin.renamePath("#{__dirname}/fixture/#{path}", "fixture")
        fs.readFileSync(path).toString().should.equal(body)