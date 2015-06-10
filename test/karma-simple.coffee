expect = require('chai').expect
path = require('path')

Robot = require('hubot/src/robot')
TextMessage = require('hubot/src/message').TextMessage

process.setMaxListeners(0)

describe 'KarmaSimple(default)', ->
  robot = undefined
  user = undefined
  adapter = undefined
  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'hubot')
    robot.adapter.on 'connected', ->
      require('../src/karma-simple') robot
      user = robot.brain.userForId('1',
        name: 'mocha'
        room: '#mocha')
      adapter = robot.adapter
      done()
      return
    robot.run()
    return
  afterEach ->
    robot.shutdown()
    return

  it '++: increment', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /hoge: 1 level up!/
      done()
      return
    adapter.receive new TextMessage(user, "hoge++")
    return

  it '--: decrement', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /hoge: -1 lost a level\./
      done()
      return
    adapter.receive new TextMessage(user, "hoge--")
    return

  it '++: multi increment', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /hoge: 1 level up!/
      done()
      return
    adapter.receive new TextMessage(user, "hoge++ hoge++ hoge++")
    return

  it '++: multibyte', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /ほげ: 1 level up!/
      done()
      return
    adapter.receive new TextMessage(user, "ほげ++")
    return

  it 'add alias', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /cannot use this command now\. \(see Configuration:/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple alias hoge page")
    return

  it 'add increment_message', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /cannot use this command now\. \(see Configuration:/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple increment_message hoge")
    return

  it 'add decrement_message', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /cannot use this command now\. \(see Configuration:/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple decrement_message hoge")
    return

  it 'add black_list', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /cannot use this command now\. \(see Configuration:/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple black_list hoge")
    return

  it 'add personal_increment_message', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /cannot use this command now\. \(see Configuration:/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple personal increment_message hoge")
    return

  it 'add personal_decrement_message', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /cannot use this command now\. \(see Configuration:/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple personal decrement_message hoge")
    return

  it 'set personal message_type', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /cannot use this command now\. \(see Configuration:/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple personal message_type personal")
    return

  return

describe 'KarmaSimple(alias)', ->
  robot = undefined
  user = undefined
  adapter = undefined
  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'hubot')
    robot.adapter.on 'connected', ->
      process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_ALIAS = "1"
      require('../src/karma-simple') robot
      user = robot.brain.userForId('1',
        name: 'mocha'
        room: '#mocha')
      adapter = robot.adapter
      done()
      return
    robot.run()
    return
  afterEach ->
    robot.shutdown()
    return

  it 'add alias', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /add hoge alias page/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple alias hoge page")
    return

describe 'KarmaSimple(increment_message)', ->
  robot = undefined
  user = undefined
  adapter = undefined
  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'hubot')
    robot.adapter.on 'connected', ->
      process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_INCREMENT_MESSAGE = "1"
      require('../src/karma-simple') robot
      user = robot.brain.userForId('1',
        name: 'mocha'
        room: '#mocha')
      adapter = robot.adapter
      done()
      return
    robot.run()
    return
  afterEach ->
    robot.shutdown()
    return

  it 'add increment_message', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /add increment_message_list Happy/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple increment_message Happy")
    return

describe 'KarmaSimple(decrement_message)', ->
  robot = undefined
  user = undefined
  adapter = undefined
  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'hubot')
    robot.adapter.on 'connected', ->
      process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_DECREMENT_MESSAGE = "1"
      require('../src/karma-simple') robot
      user = robot.brain.userForId('1',
        name: 'mocha'
        room: '#mocha')
      adapter = robot.adapter
      done()
      return
    robot.run()
    return
  afterEach ->
    robot.shutdown()
    return

  it 'add decrement_message', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /add decrement_message_list Sorry/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple decrement_message Sorry")
    return

describe 'KarmaSimple(black_list)', ->
  robot = undefined
  user = undefined
  adapter = undefined
  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'hubot')
    robot.adapter.on 'connected', ->
      process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_BLACK_LIST = "1"
      require('../src/karma-simple') robot
      user = robot.brain.userForId('1',
        name: 'mocha'
        room: '#mocha')
      adapter = robot.adapter
      done()
      return
    robot.run()
    return
  afterEach ->
    robot.shutdown()
    return

  it 'add black_list', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /add black list Hoge/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple black_list Hoge")
    return

describe 'KarmaSimple(thing black list regexp string)', ->
  robot = undefined
  user = undefined
  adapter = undefined
  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'hubot')
    robot.adapter.on 'connected', ->
      process.env.HUBOT_KARUMA_SIMPLE_THING_BLACK_LIST_REGEXP_STRING = "^([-+drwx]+)$"
      require('../src/karma-simple') robot
      user = robot.brain.userForId('1',
        name: 'mocha'
        room: '#mocha')
      adapter = robot.adapter
      done()
      return
    robot.run()
    return
  afterEach ->
    robot.shutdown()
    return

  it '-rw-rw-r--', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /hoge: 1 level up!/
      done()
      return
    adapter.receive new TextMessage(user, "-rw-rw-r-- hoge++")
    return
  it '+--------------------+', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /hoge: 1 level up!/
      done()
      return
    adapter.receive new TextMessage(user, "+--------------------+ hoge++")
    return

describe 'KarmaSimple(message black list regexp string)', ->
  robot = undefined
  user = undefined
  adapter = undefined
  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'hubot')
    robot.adapter.on 'connected', ->
      process.env.HUBOT_KARUMA_SIMPLE_MESSAGE_BLACK_LIST_REGEXP_STRING = "^(kill)$"
      require('../src/karma-simple') robot
      user = robot.brain.userForId('1',
        name: 'mocha'
        room: '#mocha')
      adapter = robot.adapter
      done()
      return
    robot.run()
    return
  afterEach ->
    robot.shutdown()
    return

  it 'message black list', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /hoge: 1 level up!/
      done()
      return
    adapter.receive new TextMessage(user, "kill")
    adapter.receive new TextMessage(user, "hoge++")
    return

  return

describe 'KarmaSimple(personal_increment_message)', ->
  robot = undefined
  user = undefined
  adapter = undefined
  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'hubot')
    robot.adapter.on 'connected', ->
      process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_PERSONAL_INCREMENT_MESSAGE = "1"
      require('../src/karma-simple') robot
      user = robot.brain.userForId('1',
        name: 'mocha'
        room: '#mocha')
      adapter = robot.adapter
      done()
      return
    robot.run()
    return
  afterEach ->
    robot.shutdown()
    return

  it 'add personal_increment_message', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /add personal increment_message_list Happy/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple personal increment_message Happy")
    return

describe 'KarmaSimple(personal_decrement_message)', ->
  robot = undefined
  user = undefined
  adapter = undefined
  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'hubot')
    robot.adapter.on 'connected', ->
      process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_PERSONAL_DECREMENT_MESSAGE = "1"
      require('../src/karma-simple') robot
      user = robot.brain.userForId('1',
        name: 'mocha'
        room: '#mocha')
      adapter = robot.adapter
      done()
      return
    robot.run()
    return
  afterEach ->
    robot.shutdown()
    return

  it 'add personal_decrement_message', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /add personal decrement_message_list Sorry/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple personal decrement_message Sorry")
    return

describe 'KarmaSimple(personal_message_type)', ->
  robot = undefined
  user = undefined
  adapter = undefined
  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'hubot')
    robot.adapter.on 'connected', ->
      process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_PERSONAL_MESSAGE_TYPE = "1"
      require('../src/karma-simple') robot
      user = robot.brain.userForId('1',
        name: 'mocha'
        room: '#mocha')
      adapter = robot.adapter
      done()
      return
    robot.run()
    return
  afterEach ->
    robot.shutdown()
    return

  it 'set personal message_type', (done) ->
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /set personal message_type personal/
      done()
      return
    adapter.receive new TextMessage(user, "hubot karma-simple personal message_type personal")
    return

  it 'set personal message_type(personal,hoge++)', (done) ->
    robot.brain.data.karma_simple['personal'] ?= {}
    robot.brain.data.karma_simple['personal']['mocha'] ?= {}
    robot.brain.data.karma_simple['personal']['mocha']['message_type'] = 'personal'
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /^hoge: 1 $/
      done()
      return
    adapter.receive new TextMessage(user, "hoge++")
    return

  it 'set personal message_type(common,hoge++)', (done) ->
    robot.brain.data.karma_simple['personal'] ?= {}
    robot.brain.data.karma_simple['personal']['hoge'] ?= {}
    robot.brain.data.karma_simple['personal']['hoge']['message_type'] = 'common'
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /^hoge: 1 level up!$/
      done()
      return
    adapter.receive new TextMessage(user, "hoge++")
    return

  it 'set personal message_type(all,hoge++)', (done) ->
    robot.brain.data.karma_simple['personal'] ?= {}
    robot.brain.data.karma_simple['personal']['hoge'] ?= {}
    robot.brain.data.karma_simple['personal']['hoge']['message_type'] = 'all'
    adapter.on 'send', (envelope, strings) ->
      expect(strings[0]).match /^hoge: 1 level up!$/
      done()
      return
    adapter.receive new TextMessage(user, "hoge++")
    return
