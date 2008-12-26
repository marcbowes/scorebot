module ScoreBot
  class Game
    include ScoreBot::GameAASM
    
    attr_accessor :name, :host, :players
    
    def ability_used_no_target(player_name, flag, id)
      # ...
    end
  end
end
