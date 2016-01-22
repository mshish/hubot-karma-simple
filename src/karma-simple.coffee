# Description:
#   Give or take away karma.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_KARUMA_SIMPLE_USE_COMMAND_INCREMENT_MESSAGE
#   HUBOT_KARUMA_SIMPLE_USE_COMMAND_DECREMENT_MESSAGE
#   HUBOT_KARUMA_SIMPLE_USE_COMMAND_PERSONAL_INCREMENT_MESSAGE
#   HUBOT_KARUMA_SIMPLE_USE_COMMAND_PERSONAL_DECREMENT_MESSAGE
#   HUBOT_KARUMA_SIMPLE_USE_COMMAND_PERSONAL_MESSAGE_TYPE
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
#   hubot karma-simple personal increment_message <message>
#   hubot karma-simple personal decrement_message <message>
#   hubot karma-simple personal message_type <all|personal|common|default>
#
# Author:
#   hiroyukim

KarmaSimpleStorage = require('./karma-simple-storage')

module.exports = (robot) ->

  karma = new KarmaSimpleStorage robot

  userForMentionName = (mentionName) ->
    for id, user of robot.brain.users()
      return user if mentionName is user.mention_name

  # User tokenization from https://github.com/rbergman/hubot-karma
  usersForToken = (token) ->
    user = robot.brain.userForName token
    return [user] if user
    user = userForMentionName token
    return [user] if user
    robot.brain.usersForFuzzyName token

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

        # Remove leading @ sign
        if thing.match("^@")
          thing = thing.substring(1, thing.length)

        # Borrowed from https://github.com/rbergman/hubot-karma
        usercompletion = usersForToken thing

        if usercompletion.length is 1
          thing = usercompletion[0].name

        msg_thing   = thing

        alias_thing = karma.get_alias(thing)
        if alias_thing
            msg_thing = alias_thing

        if op == '++'
            karma.increment thing
            increment_message = karma.get_message_from_personal_message_type(msg.message.user.name,'increment_message_list')
            msg.send "#{msg_thing}: #{karma.get_with_alias(msg_thing)} #{increment_message || ''}"
        else
            karma.decrement thing
            decrement_message = karma.get_message_from_personal_message_type(msg.message.user.name,'decrement_message_list')
            msg.send "#{msg_thing}: #{karma.get_with_alias(msg_thing)} #{decrement_message || ''}"

  robot.respond /karma-simple alias ([^\s]+) ([^\s]+)/, (msg) ->
    thing      = msg.match[1]
    alias_name = msg.match[2]

    unless karma.use_command_alias
        msg.send "cannot use this command now. (see Configuration:"
        return

    if karma.get_alias alias_name
        karma.delete_alias alias_name
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

  robot.respond /karma-simple (increment_message|decrement_message) (.+)?/, (msg) ->

    type    = msg.match[1]
    message = msg.match[2]

    use_command_type = "use_command_#{type}"
    message_type     = "#{type}_list"

    unless karma[use_command_type]
        msg.send "cannot use this command now. (see Configuration:"
        return

    if karma.message_regexp_row.test(message)
        msg.send "unable to register"
        return

    if karma.has_message_list message_type,message
        karma.delete_message_list message_type,message
        msg.send "delete #{message_type} #{message}"
    else
        karma.add_message_list message_type,message
        msg.send "add #{message_type} #{message}"

  robot.respond /karma-simple personal (increment_message|decrement_message) (.+)/, (msg) ->

    type      = msg.match[1]
    message   = msg.match[2]
    user_name = msg.message.user.name

    use_command_type = "use_command_personal_#{type}"
    message_type     = "#{type}_list"

    unless karma[use_command_type]
        msg.send "cannot use this command now. (see Configuration:"
        return

    if karma.message_regexp_row.test(message)
        msg.send "unable to register"
        return

    if karma.has_personal_message_list user_name,message_type,message
        karma.delete_personal_message_list user_name,message_type,message
        msg.send "delete personal #{message_type} #{message}"
    else
        karma.add_personal_message_list user_name,message_type,message
        msg.send "add personal #{message_type} #{message}"

  robot.respond /karma-simple personal message_type (default|personal|common|all)/, (msg) ->

    message_type = msg.match[1]
    user_name    = msg.message.user.name

    unless karma.use_command_personal_message_type
        msg.send "cannot use this command now. (see Configuration:"
        return

    karma.set_personal_message_type user_name,message_type
    msg.send "set personal message_type #{message_type}"
