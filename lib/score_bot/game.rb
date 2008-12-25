# This is quite messy.. I don't know of a cleaner way to load AASM
require 'rubygems'
gem     'rubyist-aasm'
require 'aasm'

module ScoreBot
  class Game
    include AASM
    
    aasm_initial_state :lobby

    aasm_state :complete
    aasm_state :lobby
    aasm_state :paused
    aasm_state :playing
    
    aasm_event :finish do
      transitions :to => :complete, :from => :playing
    end
    
    aasm_event :pause do
      transitions :to => :paused, :from => :playing
    end
    
    aasm_event :resume do
      transitions :to => :playing, :from => :paused
    end
    
    aasm_event :start do
      transitions :to => :playing, :from => :lobby
    end
  end
end
