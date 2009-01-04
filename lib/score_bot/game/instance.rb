module ScoreBot
  module Game
  
    class Instance
      include States
      
      attr_accessor :name, :host
      
      def ability_used_no_target(player, flag, id)
        # this method is used to set the player's hero
        # so if they already have one, nobody cares
        # hero swapping is set by interpreting the -swap command
        return unless @players.include? player
        return unless @players[player][:hero].nil?
        
        # "Equinox", "66", "1093684036"
        # ["%x" % "1093678644"].pack("H*") => "A064"
        ability = ["%x" % id].pack("H*")
        
        hero = ScoreBot::Game::Util.ability_to_hero_name(ability)
        return if hero.nil?
        
        @players[player][:hero] = hero
      end
      
      def find_player_by_slot(slot)
        @players.each_key do |player|
          return player if @players[player][:slot] == slot
        end
        nil
      end
      
      def players=(players)
        @players = players
        build_virtual_players
      end
      
      def player_colour(player)
        return nil unless @players.include? player
        
        case @players[player][:slot]
          when 0  # The Sentinel
                       'red'
          when 1  then 'blue'
          when 2  then 'aqua'
          when 3  then 'purple'
          when 4  then 'yellow'
          when 5  then 'orange'
          when 6  # The Scourge
                       'green'
          when 7  then 'fuchsia'
          when 8  then 'grey'
          when 9  then 'royal'
          when 10 then 'green'
          when 11 then 'brown'
          when 12..13 # Spectators
                       'white'
          else         
                       'white'
        end
      end
      
      def sync_stored_integer(key1, key2, value)
        # key1 is always 'Data'?
        if key2    =~ /hero/
          killer_slot, victim_slot = value.to_i, key2.sub('hero', '').to_i
          { :killer   => find_player_by_slot(killer_slot),
            :action   => is_same_team(killer_slot, victim_slot) ? 'denied' : 'pawned',
            :victim   => find_player_by_slot(victim_slot) }
        elsif key2 =~ /tower/
          keys = key2.sub('tower', '').split(//)
          killer_slot, owner_slot = value.to_i, (keys[0].to_i == 0 ? 0 : 6)
          { :killer   => find_player_by_slot(killer_slot),
            :action   => is_same_team(killer_slot, owner_slot) ? 'denied' : 'destroyed',
            :owner    => find_player_by_slot(owner_slot),
            :lane     => id_to_lane(keys[2].to_i),
            :position => id_to_position(keys[1].to_i) }
        elsif key2 =~ /rax/
          keys = key2.sub('rax', '').split(//)
          killer_slot, owner_slot = value.to_i, (keys[0].to_i == 0 ? 0 : 6)
          { :killer   => find_player_by_slot(killer_slot),
            :action   => is_same_team(killer_slot, owner_slot) ? 'denied' : 'destroyed',
            :owner    => find_player_by_slot(owner_slot),
            :lane     => id_to_lane(keys[1].to_i),
            :type     => id_to_type(keys[2].to_i, owner_slot) }
        elsif key2 =~ /tree/
          nil
        elsif key2 =~ /throne/
          nil
        else
          nil
        end
      end
      
      protected
      
      def build_virtual_players
        @players.merge!({
          'The Sentinel' => { :slot => 0 },
          'The Scourge'  => { :slot => 6 }
        })
      end
      
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
      
      def is_same_team(a, b)
        return true if a < 6 and b < 6 and a >= 0 and b >= 0
        return true if a < 12 and b < 12 and a >= 6 and b >= 6
        # maybe spectators handled later.. ? not sure :/
        false
      end
    end
    
  end
end
