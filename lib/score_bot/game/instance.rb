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
        # key1 is always 'Data'?
        key2.downcase!
        if key2    =~ /hero/
          { :killer   => player.find_by_slot(value),
            :victim   => key2.sub('hero', '') }
        elsif key2 =~ /tower/
          keys = key2.sub('tower', '').split(//)
          { :killer   => player.find_by_slot(value),
            :owner    => keys[0].to_i,
            :lane     => id_to_lane(keys[2].to_i),
            :position => id_to_position(keys[1].to_i) }
        elsif key2 =~ /rax/
          keys = key2.sub('rax', '').split(//)
          { :killer   => player.find_by_slot(value),
            :owner    => keys[0].to_i,
            :lane     => id_to_lane(keys[1].to_i),
            :type     => id_to_type(keys[2].to_i) }
        elsif key2 =~ /tree/
          nil
        elsif key2 =~ /throne/
          nil
        else
          nil
        end
      end
      
      protected
      
      LANE_MAP = {
        0 => 'top',
        1 => 'middle',
        2 => 'bottom'
      }
      
      def id_to_lane(id)
        LANE_MAP[id]
      end
      
      POSITION_MAP = {
        1 => 'first',
        2 => 'second',
        3 => 'base',
        4 => 'ancient'
      }
      
      def id_to_position(id)
        POSITION_MAP[id]
      end
      
      TYPE_MAP = {
        0 => { 0 => 'Ancient of War', 1 => 'Ancient of Lore' },
        1 => { 0 => 'Crypt',          1 => 'Temple of the Damned'}
      }
      
      def id_to_type(id, owner)
        TYPE_MAP[owner][id]
      end
    end
    
  end
end
