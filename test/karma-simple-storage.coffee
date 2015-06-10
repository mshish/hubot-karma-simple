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
      s.add_message_list('increment_message_list','thing')
      expect(s.cache.increment_message_list).to.include('thing')

    it 'delete_increment_message_list to increment_message_list', ->
      s.delete_message_list('increment_message_list','thing')
      expect(s.cache.increment_message_list).to.not.include('thing')

  describe 'decrement_message_list', ->

    it 'add_decrement_message_list to decrement_message_list', ->
      s.add_message_list('decrement_message_list','thing')
      expect(s.cache.decrement_message_list).to.include('thing')

    it 'delete_decrement_message_list to decrement_message_list', ->
      s.delete_message_list('decrement_message_list','thing')
      expect(s.cache.decrement_message_list).to.not.include('thing')

  describe 'alias', ->
    it 'set|get alias', ->
      s.set_alias('thing','alias_name')
      expect(s.get_alias('alias_name')).to.equal('thing')

    it 'delete alias', ->
      s.delete_alias('alias_name')
      expect(s.get_alias('alias_name')).to.undefined

  describe 'black_list', ->
    it 'set black_list', ->
      s.set_black_list('thing')
      expect(s.has_black_list('thing')).is.true

    it 'delete black_list', ->
      s.set_black_list('thing')
      s.delete_black_list('thing')
      expect(s.has_black_list('thing')).is.undefined

  describe 'personal increment_message_list', ->

    it 'add|delete_personal_increment_message_list to personal.user_name.increment_message_list', ->
      s.add_personal_message_list('hoge','increment_message_list','thing')
      expect(s.cache['personal']['hoge']['increment_message_list']).to.include('thing')

      s.delete_personal_message_list('hoge','increment_message_list','thing')
      expect(s.cache['personal']['hoge']['increment_message_list']).to.not.include('thing')

  describe 'personal message_type', ->

    it 'undefined get_personal_message_type', ->
      message_type = s.get_personal_message_type('hoge')
      expect(message_type).to.undefined

    it 'set|get_personal_message_type', ->
      s.set_personal_message_type('hoge','personal')
      message_type = s.get_personal_message_type('hoge')
      expect(message_type).to.equal('personal')

    it 'get_message_from_personal_message_type(default)', ->
      message = s.get_message_from_personal_message_type('hoge','increment_message_list')
      expect(message).to.equal('level up!')

    it 'get_message_from_personal_message_type(personal)', ->
      s.set_personal_message_type('hoge','personal')
      message = s.get_message_from_personal_message_type('hoge','increment_message_list')
      expect(message).to.undefined

    it 'get_message_from_personal_message_type(common)', ->
      s.set_personal_message_type('hoge','common')
      message = s.get_message_from_personal_message_type('hoge','increment_message_list')
      expect(message).to.equal('level up!')

    it 'get_message_from_personal_message_type(all)', ->
      s.set_personal_message_type('hoge','all')
      message = s.get_message_from_personal_message_type('hoge','increment_message_list')
      expect(message).to.equal('level up!')
