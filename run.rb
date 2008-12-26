require 'lib/scorebot'

scorebot_server = ScoreBot::Server.new
scorebot_server.audit = true
scorebot_server.start

irc_client = ScoreBot::IRC::Client.new
irc_client.connect!

scorebot_server.irc = irc_client

irc_client.join
server.join
