# Description:
#   "Accepts POST data and broadcasts it"
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLs:
#   POST /hubot/say
#     msg = <room>,<message>
#
#   curl -X POST http://localhost:8080/hubot/say -d msg=#dev,lala
#
# Author:
#   Drunkar

module.exports = (robot) ->
  robot.router.post "/hubot/say", (req, res) ->
    msg = req.body.msg.split(",")[0]
    room = msg[0]
    message = msg.slice(1).join("")

    robot.logger.info "Message '#{message}' received for room #{room}"

    envelope = robot.brain.userForId 'broadcast'
    envelope.user = {}
    envelope.user.room = envelope.room = room if room
    envelope.user.type = 'groupchat'

    if message
      robot.send envelope, message

    res.writeHead 200, {'Content-Type': 'text/plain'}
    res.end 'Thanks\n'
