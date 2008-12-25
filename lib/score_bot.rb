# require farm for score_bot lib

# add to ruby search path.. makes things easier
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'score_bot/game'
require 'score_bot/incoming_message_handler'
require 'score_bot/server'
