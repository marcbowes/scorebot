require 'lib/scorebot'

server = ScoreBot::Server.new
server.audit = true
server.start
server.join
