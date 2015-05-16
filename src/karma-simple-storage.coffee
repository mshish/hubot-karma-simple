# Description:
#   Helper class responsible for storing karmas
#
# Dependencies:
#
# Configuration:
#
# Commands:
#
# Author:
#  hiroyukim

class KarmaSimpleStorage

  constructor: (@robot) ->
    cacheLoaded = =>
      @cache = @robot.brain.data.karma_simple ||= {
        data: {}
        alias: {}
        black_list: {}
        increment_message_list: []
        decrement_message_list: []
      }

    message_regexp_string = "([^\\s]+)(\\+\\+|--)"

    @use_command_increment_message    = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_INCREMENT_MESSAGE
    @use_command_decrement_message    = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_DECREMENT_MESSAGE
    @use_command_black_list           = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_BLACK_LIST
    @use_command_alias                = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_ALIAS

    @message_regexp     = new RegExp(message_regexp_string,"g","m")
    @message_regexp_row = new RegExp(message_regexp_string)
    @thing_black_list_regexp =
        if process.env.HUBOT_KARUMA_SIMPLE_THING_BLACK_LIST_REGEXP_STRING then new RegExp(process.env.HUBOT_KARUMA_SIMPLE_THING_BLACK_LIST_REGEXP_STRING) else null
    @message_black_list_regexp =
        if process.env.HUBOT_KARUMA_SIMPLE_MESSAGE_BLACK_LIST_REGEXP_STRING then new RegExp(process.env.HUBOT_KARUMA_SIMPLE_MESSAGE_BLACK_LIST_REGEXP_STRING) else null
    @room_black_list_regexp =
        if process.env.HUBOT_KARUMA_SIMPLE_ROOM_BLACK_LIST_REGEXP_STRING then new RegExp(process.env.HUBOT_KARUMA_SIMPLE_ROOM_BLACK_LIST_REGEXP_STRING) else null

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

module.exports = KarmaSimpleStorage
