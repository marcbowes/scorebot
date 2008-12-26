# require farm for score_bot lib

# This is quite messy.. I don't know of a cleaner way to load AASM
require 'rubygems'
gem     'rubyist-aasm'
require 'aasm'

# add to ruby search path.. makes things easier
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

# score_bot libs
require 'score_bot/game_aasm'
require 'score_bot/game'
require 'score_bot/incoming_message_handler'
require 'score_bot/server'
