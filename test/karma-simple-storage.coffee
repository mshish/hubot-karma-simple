chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

KarmaSimpleStorage = require '../src/karma-simple-storage.coffee'

robotStub = {}

describe 'KarmaSimpleStorage', ->
  s = {}

  beforeEach ->
    robotStub =
      brain:
        data: { }
        on: ->
        emit: ->
        save: ->
      logger:
        debug: ->
    s = new KarmaSimpleStorage (robotStub)

  describe 'increment', ->
    it 'increment karma to a user', ->
      s.increment('thing')
      expect(s.get_with_alias('thing')).to.equal(1)

