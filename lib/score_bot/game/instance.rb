module ScoreBot
  module Game
    class Instance
      include States
      
      attr_accessor :name, :host, :players
      
      def ability_used_no_target(player, flag, id)
        # this method is used to set the player's hero
        # so if they already have one, nobody cares
        # hero swapping is set by interpreting the -swap command
        return unless players[player][:hero].nil?
        
        # "Equinox", "66", "1093684036"
        # ["%x" % "1093678644"].pack("H*") => "A064"
        ability = ["%x" % id].pack("H*")
        
        hero = ScoreBot::GameUtil.ability_to_hero_name(ability)
        return if hero.nil?
        
        players[player][:hero] = hero
      end
      
      def sync_stored_integer(key1, key2, value)
        
      end
    end
  end
end
