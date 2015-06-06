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
_ = require 'underscore'

class KarmaSimpleStorage

  constructor: (@robot) ->
    cacheLoaded = =>
      @cache = @robot.brain.data.karma_simple ||= {
        data: {}
        alias: {}
        black_list: {}
        increment_message_list: []
        decrement_message_list: []
        personal: {}
      }

    message_regexp_string = "([^\\s]+)(\\+\\+|--)"

    @use_command_increment_message    = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_INCREMENT_MESSAGE
    @use_command_decrement_message    = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_DECREMENT_MESSAGE
    @use_command_black_list           = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_BLACK_LIST
    @use_command_alias                = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_ALIAS
    @use_command_personal_increment_message    = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_PERSONAL_INCREMENT_MESSAGE
    @use_command_personal_decrement_message    = process.env.HUBOT_KARUMA_SIMPLE_USE_COMMAND_PERSONAL_DECREMENT_MESSAGE

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

    @cache['personal'] ?= {}

    unless @cache['increment_message_list'].length
        @cache['increment_message_list'].push 'level up!'

    unless @cache['decrement_message_list'].length
        @cache['decrement_message_list'].push 'lost a level.'

  add_personal_message_list: (user_name,type,message) ->
    @cache['personal'][user_name] ?= {}
    @cache['personal'][user_name][type] ?= []
    @cache['personal'][user_name][type].push message

  delete_personal_message_list: (user_name,type,message) ->
    unless @cache['personal'][user_name]
        return
    unless @cache['personal'][user_name][type]
        return
    for value,index in @cache['personal'][user_name][type]
        if value == message
            @cache['personal'][user_name][type].splice(index,1)
            @robot.brain.data.karma_simple = @cache
            break

  get_personal_message: (user_name,type,message) ->
    unless @cache['personal'][user_name]
        return
    unless @cache['personal'][user_name][type]
        return

    @cache['personal'][user_name][type][Math.floor(Math.random() * @cache['personal'][user_name][type].length)]

  get_personal_message_list: (user_name,type) ->
    unless @cache['personal'][user_name]
        return
    unless @cache['personal'][user_name][type]
        return

    @cache['personal'][user_name][type]

  has_personal_message_list: (user_name,type,message) ->
    unless @cache['personal'][user_name]
        return
    unless @cache['personal'][user_name][type]
        return

    _.contains @cache['personal'][user_name][type], message

  add_message_list: (type,message) ->
    @cache[type].push message
    @robot.brain.data.karma_simple = @cache

  delete_message_list: (type,message) ->
    for value,index in @cache[type]
        if value == message
            @cache[type].splice(index,1)
            @robot.brain.data.karma_simple = @cache
            break

  get_message: (type,message) ->
    @cache[type][Math.floor(Math.random() * @cache[type].length)]

  get_message_list: (type) ->
    @cache[type]

  has_message_list: (type,message) ->
    for increment_message in @cache[type]
        if increment_message == message
            return true
    return

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
