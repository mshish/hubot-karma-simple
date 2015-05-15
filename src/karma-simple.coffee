# Description:
#   Give or take away karma.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_KARUMA_SIMPLE_USE_COMMAND_INCREMENT_MESSAGE
#   HUBOT_KARUMA_SIMPLE_USE_COMMAND_DECREMENT_MESSAGE
#   HUBOT_KARUMA_SIMPLE_USE_COMMAND_BLACK_LIST
#   HUBOT_KARUMA_SIMPLE_USE_COMMAND_ALIAS
#   HUBOT_KARUMA_SIMPLE_THING_BLACK_LIST_REGEXP_STRING
#   HUBOT_KARUMA_SIMPLE_MESSAGE_BLACK_LIST_REGEXP_STRING
#   HUBOT_KARUMA_SIMPLE_ROOM_BLACK_LIST_REGEXP_STRING
#
# Commands:
#   <thing>++ - give thing some karma
#   <thing>-- - take away some of thing's karma
#   hubot karma-simple alias <thing> <alias thing>
#   hubot karma-simple black_list <thing>
#   hubot karma-simple increment_message <message>
#   hubot karma-simple decrement_message <message>
#
# Author:
#   hiroyukim

class KarmaSimple

  constructor: (@robot) ->
    cacheLoaded = =>
      @cache = @robot.brain.data.karma_simple ||= {
        data: {}
        alias: {}
        black_list: {}
        increment_message_list: []
        decrement_message_list: []
      }

    @message_regexp_string = "([^\\s]+)(\\+\\+|--)"

    @use_command_increment_message    = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_INCREMENT_MESSAGE
    @use_command_decrement_message    = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_DECREMENT_MESSAGE
    @use_command_black_list           = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_BLACK_LIST
    @use_command_alias                = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_ALIAS
    @thing_black_list_regexp_string   = process.env.HUBOT_KARUMA_SIMPLE_THING_BLACK_LIST_REGEXP_STRING
    @message_black_list_regexp_string = process.env.HUBOT_KARUMA_SIMPLE_MESSAGE_BLACK_LIST_REGEXP_STRING
    @room_black_list_regexp_string    = process.env.HUBOT_KARUMA_SIMPLE_ROOM_BLACK_LIST_REGEXP_STRING

    @robot.brain.on "loaded", cacheLoaded
    cacheLoaded()

    unless @cache['increment_message_list'].length
        @cache['increment_message_list'].push 'level up!'

    unless @cache['decrement_message_list'].length
        @cache['decrement_message_list'].push 'lost a level.'

  add_increment_message_list: (message) ->
    @cache['increment_message_list'].push message
    @robot.brain.data.karma_simple = @cache

  delete_increment_message_list: (message) ->
    for value,index in @cache['increment_message_list']
        if value == message
            @cache['increment_message_list'].splice(index,1)
            @robot.brain.data.karma_simple = @cache
            break

  delete_decrement_message_list: (message) ->
    for value,index in @cache['decrement_message_list']
        if value == message
            @cache['decrement_message_list'].splice(index,1)
            @robot.brain.data.karma_simple = @cache
            break

  get_increment_message: (message) ->
    @cache['increment_message_list'][Math.floor(Math.random() * @cache['increment_message_list'].length)]

  get_increment_message_list: ->
    @cache['increment_message_list']

  has_increment_message_list: (message) ->
    for increment_message in @cache['increment_message_list']
        if increment_message == message
            return true
    return

  has_decrement_message_list: (message) ->
    for decrement_message in @cache['decrement_message_list']
        if decrement_message == message
            return true
    return

  add_decrement_message_list: (message) ->
    @cache['decrement_message_list'].push message
    @robot.brain.data.karma_simple = @cache

  get_decrement_message: (message) ->
    @cache['decrement_message_list'][Math.floor(Math.random() * @cache['decrement_message_list'].length)]

  get_decrement_message_list: ->
    @cache['decrement_message_list']

  set_alias: (thing,alias_name) ->
    @cache['alias'][alias_name] = thing
    @robot.brain.data.karma_simple = @cache

  get_alias: (alias_name) ->
    return @cache['alias'][alias_name]

  get_alias_list: (thing) ->
    alias_list = []
    for alias in Object.keys(@cache['alias'])
        alias_thing = @cache['alias'][alias]
        if thing == alias_thing
            alias_list.push alias
    return alias_list

  delete_alias: (alias_name) ->
    delete @cache['alias'][alias_name]
    @robot.brain.data.karma_simple = @cache

  has_black_list: (thing) ->
    return @cache['black_list'][thing]

  set_black_list: (thing) ->
     @cache['black_list'][thing] = true
     @robot.brain.data.karma_simple = @cache

  delete_black_list: (thing) ->
     delete @cache['black_list'][thing]
     @robot.brain.data.karma_simple = @cache

  get_black_list: ->
    black_list = []
    for black in Object.keys(@cache['black_list'])
        black_list.push black
    return black_list

  increment: (thing) ->
    @cache['data'][thing] ?= 0
    @cache['data'][thing] += 1
    @robot.brain.data.karma_simple = @cache

  decrement: (thing) ->
    @cache['data'][thing] ?= 0
    @cache['data'][thing] -= 1
    @robot.brain.data.karma_simple = @cache

  get: (thing) ->
    k = if @cache['data'][thing] then @cache['data'][thing] else 0
    return k

  get_with_alias: (thing) ->
    k = @get(thing)
    for alias in @get_alias_list(thing)
        k += @get(alias)
    return k

module.exports = (robot) ->

  karma = new KarmaSimple robot

  message_regexp            = new RegExp(karma.message_regexp_string,"g","m")
  message_regexp_row        = new RegExp(karma.message_regexp_string)
  thing_black_list_regexp   = if karma.thing_black_list_regexp_string   then new RegExp(karma.thing_black_list_regexp_string) else null
  message_black_list_regexp = if karma.message_black_list_regexp_string then new RegExp(karma.message_black_list_regexp_string) else null
  room_black_list_regexp    = if karma.room_black_list_regexp_string    then new RegExp(karma.room_black_list_regexp_string) else null

  robot.hear message_regexp, (msg) ->

    if room_black_list_regexp && room_black_list_regexp.test(msg.message.room)
        return

    if message_black_list_regexp && message_black_list_regexp.test(msg.message.toString())
        return
    
    for row in msg.match
        match_row = row.match(message_regexp_row)
        thing = match_row[1]
        op    = match_row[2]

        if karma.has_black_list(thing)
            continue

        if thing_black_list_regexp && thing_black_list_regexp.test(thing)
            continue

        msg_thing   = thing
        alias_thing = karma.get_alias(thing)
        if alias_thing
            msg_thing = alias_thing

        if op == '++'
            karma.increment thing
            msg.send "#{msg_thing}: #{karma.get_with_alias(msg_thing)} #{karma.get_increment_message()}"
        else
            karma.decrement thing
            msg.send "#{msg_thing}: #{karma.get_with_alias(msg_thing)} #{karma.get_decrement_message()}"

  robot.respond /karma-simple alias ([^\s]+) ([^\s]+)/, (msg) ->
    thing      = msg.match[1]
    alias_name = msg.match[2]

    unless karma.use_command_alias
        msg.send "cannot use this command now. (see Configuration:"
        return

    if karma.get_alias thing
        karma.delete_alias thing
        msg.send "delete #{thing} alias #{alias_name}"
    else
        karma.set_alias thing, alias_name
        msg.send "add #{thing} alias #{alias_name}"

  robot.respond /karma-simple black_list\s?([^\s]+)?/, (msg) ->
    black = msg.match[1]

    unless karma.use_command_black_list
        msg.send "cannot use this command now. (see Configuration:"
        return

    unless black
        for value,key in karma.get_black_list()
             msg.send "#{key} #{value}"
        return

    if karma.has_black_list black
        karma.delete_black_list black
        msg.send "delete black list #{black}"
    else
        karma.set_black_list black
        msg.send "add black list #{black}"

  robot.respond /karma-simple increment_message (.+)?/, (msg) ->
    
    unless karma.use_command_increment_message
        msg.send "cannot use this command now. (see Configuration:"
        return
    
    increment_message = msg.match[1]
    
    if message_regexp_row.test(increment_message)
        msg.send "unable to register"
        return

    if karma.has_increment_message_list increment_message
        karma.delete_increment_message_list increment_message
        msg.send "delete increment_message #{increment_message}"
    else
        karma.add_increment_message_list increment_message
        msg.send "add increment_message #{increment_message}"

  robot.respond /karma-simple decrement_message (.+)?/, (msg) ->
    
    unless karma.use_command_decrement_message
        msg.send "cannot use this command now. (see Configuration:"
        return

    decrement_message = msg.match[1]

    if message_regexp_row.test(decrement_message)
        msg.send "unable to register"
        return

    if karma.has_decrement_message_list decrement_message
        karma.delete_decrement_message_list decrement_message
        msg.send "delete decrement_message #{decrement_message}"
    else
        karma.add_decrement_message_list decrement_message
        msg.send "add decrement_message #{decrement_message}"

