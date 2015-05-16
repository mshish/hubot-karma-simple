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

KarmaSimpleStorage = require('./karma-simple-storage')

module.exports = (robot) ->

  karma = new KarmaSimpleStorage robot

  robot.hear karma.message_regexp, (msg) ->

    if karma.room_black_list_regexp && karma.room_black_list_regexp.test(msg.message.room)
        return

    if karma.message_black_list_regexp && karma.message_black_list_regexp.test(msg.message.toString())
        return

    for row in msg.match
        match_row = row.match(karma.message_regexp_row)
        thing = match_row[1]
        op    = match_row[2]

        if karma.has_black_list(thing)
            continue

        if karma.thing_black_list_regexp && karma.thing_black_list_regexp.test(thing)
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

