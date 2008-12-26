module ScoreBot
  module Game
  
    class Instance
      include States
      
      attr_accessor :name, :host, :players
      
      def ability_used_no_target(player, flag, id)
        # this method is used to set the player's hero
        # so if they already have one, nobody cares
        # hero swapping is set by interpreting the -swap command
        return unless players.include? player
        return unless players[player][:hero].nil?
        
        # "Equinox", "66", "1093684036"
        # ["%x" % "1093678644"].pack("H*") => "A064"
        ability = ["%x" % id].pack("H*")
        
        hero = ScoreBot::Game::Util.ability_to_hero_name(ability)
        return if hero.nil?
        
        players[player][:hero] = hero
      end
      
      def player_colour(player)
        return nil unless players.include? player
        
        case players[player][:slot]
          # when 0    # The Sentinel
          when 1  then 'blue'
          when 2  then 'aqua'
          when 3  then 'purple'
          when 4  then 'yellow'
          when 5  then 'orange'
          # when 6    # The Scourge
          when 7  then 'fuchsia'
          when 8  then 'grey'
          when 9  then 'royal'
          when 10 then 'green'
          when 11 then 'brown'
          when 12..13 # Spectators
                       'white'
          else         'white'
        end
      end
      
      def sync_stored_integer(key1, key2, value)
        # ..
      end
    end
    
  end
end
