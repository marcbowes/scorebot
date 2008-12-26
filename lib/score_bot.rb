# require farm for score_bot lib

# add to ruby search path.. makes things easier
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

# score_bot libs
# -- game
require 'open-uri' # load hero list
# (this is quite messy, easier way to load aasm?)
require 'rubygems'
gem     'rubyist-aasm'
require 'aasm'
require 'score_bot/game/util'
require 'score_bot/game/states'
require 'score_bot/game/instance'
# -- irc
require 'IRC'
require 'thread'
require 'score_bot/irc/callbacks'
require 'score_bot/irc/commands'
require 'score_bot/irc/message'
require 'score_bot/irc/messages'
require 'score_bot/irc/client'
# -- base
require 'score_bot/incoming_message_handler'
require 'score_bot/server'
