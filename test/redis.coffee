# Common

common   = require '../lib/common'
Backbone = common.Backbone
redis    = common.redis

# Models

Model      = require '../lib/backbone/redis-model'
Collection = require '../lib/backbone/redis-collection'

# Specs

describe 'Backbone.sync (redis)', ->

  Backbone.sync = require '../lib/backbone/redis-sync'

  class User extends Model
    sync: (method, model, options) ->
      if [ 'create', 'delete', 'update' ].indexOf(method) > -1
        options.scopes = [ 'test_scope', 'test_scopes' ]
      @urlRoot = "users"
      @set(id: @get('login'))
      Backbone.sync(method, model, options)

  class Users extends Collection
    model: User
    constructor: (options, attributes) ->
      options ||= {}
      @scope    = options.scope
      super(attributes)
    sync: (method, model, options) ->
      if method == 'read'
        options.scope = @scope
      @url = "users"
      @each (item) -> item.sync()
      Backbone.sync(method, model, options)

  beforeEach (done) ->
    redis.del 'users', ->
      redis.del 'test_scope', ->
        redis.del 'test_scopes', done

  it 'should incrementally update record', (done) ->
    user = new User(login: 'me')
    user.save {}, success: ->
      user.toJSON().should.eql(login: 'me', id: 'me')
      users = new Users
      users.fetch success: ->
        users.toJSON().should.eql([ login: 'me', id: 'me' ])
        user.save { name: 'Tester' }, success: ->
          user.toJSON().should.eql(login: 'me', id: 'me', name: 'Tester')
          users.at(0).toJSON().should.eql(login: 'me', id: 'me')
          users.at(0).save { email: 'me@me.com' }, success: (model) ->
            model.toJSON().should.eql(login: 'me', id: 'me', email: 'me@me.com', name: 'Tester')
            redis.hget 'users', 'me', (e, json) ->
              JSON.parse(json).should.eql(login: 'me', id: 'me', email: 'me@me.com', name: 'Tester')
              user.save { name: 'Testee' }, success: ->
                user.toJSON().should.eql(login: 'me', id: 'me', name: 'Testee', email: 'me@me.com')
                user.unset('name')
                user.save {}, success: ->
                  user.toJSON().should.eql(login: 'me', id: 'me', email: 'me@me.com')
                  redis.hget 'users', 'me', (e, json) ->
                    JSON.parse(json).should.eql(login: 'me', id: 'me', email: 'me@me.com')
                    done()

  it 'should add record to scopes', (done) ->
    user = new User(login: 'me')
    user.save {}, success: ->
      redis.smembers 'test_scope', (e, keys) ->
        keys.should.eql([ 'users/me' ])
        redis.smembers 'test_scopes', (e, keys) ->
          keys.should.eql([ 'users' ])
          done()

  it 'should read scopes', (done) ->
    user = new User(login: 'me')
    user.save {}, success: ->
      users = new Users(scope: 'test_scope')
      users.fetch success: ->
        users.toJSON().should.eql([ { login: 'me', id: 'me' } ])
        users = new Users(scope: 'test_scopes')
        users.fetch success: ->
          users.toJSON().should.eql([ { login: 'me', id: 'me' } ])
          done()

  it 'should delete scopes', (done) ->
    user = new User(login: 'me')
    user.save {}, success: ->
      redis.smembers 'test_scope', (e, keys) ->
        keys.should.eql([ 'users/me' ])
        redis.smembers 'test_scopes', (e, keys) ->
          keys.should.eql([ 'users' ])
          user.destroy success: ->
            redis.smembers 'test_scope', (e, keys) ->
              keys.should.eql([])
              redis.smembers 'test_scopes', (e, keys) ->
                keys.should.eql([])
                done()