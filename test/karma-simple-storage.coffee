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

  describe 'decrement', ->
    it 'decrement karma to a user', ->
      s.decrement('thing')
      expect(s.get_with_alias('thing')).to.equal(-1)

  describe 'increment_message_list', ->

    it 'add_increment_message_list to increment_message_list', ->
      s.add_increment_message_list('thing')
      expect(s.cache.increment_message_list).to.include('thing')

    it 'delete_increment_message_list to increment_message_list', ->
      s.delete_increment_message_list('thing')
      expect(s.cache.increment_message_list).to.not.include('thing')

  describe 'decrement_message_list', ->

    it 'add_decrement_message_list to decrement_message_list', ->
      s.add_decrement_message_list('thing')
      expect(s.cache.decrement_message_list).to.include('thing')

    it 'delete_decrement_message_list to decrement_message_list', ->
      s.delete_decrement_message_list('thing')
      expect(s.cache.decrement_message_list).to.not.include('thing')
