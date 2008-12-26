require 'lib/scorebot'

server = ScoreBot::Server.new
server.audit = true
server.start

broadcast = ScoreBot::IRC::Client.new
broadcast.connect!

broadcast.join
server.join
