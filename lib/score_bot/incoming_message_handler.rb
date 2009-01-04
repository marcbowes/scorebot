module ScoreBot

  module IncomingMessageHandler
    include ScoreBot::IRC::Decorations
    
    def handle_incoming_line(game, incoming)
      split = incoming.split
      return if split.empty?
      send("handle_#{split.first.downcase}", game, incoming)
    end
    
    def broadcast(game, h)
      return unless h.include?(:event)
      case h[:event]
        when 'hero selected'  # :player, :hero
          irc.send_channel_message irc.home, "#{pc game, h[:player]} has selected #{h[:hero]}"
        when 'all chat'       # :player, :chat
          irc.send_channel_message irc.home, "#{pc game, h[:player]} (all): #{h[:chat]}"
        when 'team chat'      # ..
          irc.send_channel_message irc.home, "#{pc game, h[:player]} (team): #{h[:chat]}"
        when 'lobby chat'     # ..
          irc.send_channel_message irc.home, "#{h[:player]}: #{h[:chat]}"
        when 'game created'   # :name, :host
          irc.send_channel_message irc.home, "#{game.name} hosted by #{game.host}"
        when 'game over'      # nothing
          irc.send_channel_message irc.home, "#{game.name} is over"
        when 'pause'          # :player
          irc.send_channel_message irc.home, "#Game paused by #{pc game, h[:player]}"
        when 'player joined'  # :player
          irc.send_channel_message irc.home, "#{h[:player]} has joined the game"
        when 'player left'    # :player
          irc.send_channel_message irc.home, "#{h[:player]} has left the game"
        when 'game started'   # nothing
          irc.send_channel_message irc.home, "#{game.name} has started"
        when 'unpause'        # :player
          irc.send_channel_message irc.home, "#Game paused by #{pc game, h[:player]}"
        when 'hero death'     # :killer, :action, :victim
          irc.send_channel_message irc.home, "#{pc game, h[:killer]} #{h[:action]} #{pc game, h[:victim]}'s head!"
        when 'tower death'    # :killer, :action, :owner, :lane, :position
          irc.send_channel_message irc.home,
            "#{pc game, h[:killer]} #{h[:action]} #{h[:owner]}'s #{h[:position]} #{h[:lane]} tower"
        when 'rax death'      # :killer, :action, :owner, :lane, :type
          irc.send_channel_message irc.home,
            "#{pc game, h[:killer]} #{h[:action]} #{h[:owner]}'s #{h[:lane]} #{h[:type]} rax"
      end
    end
    
    protected
    
    def handle_ability(game, incoming)
      # ability used with no target
      # ABILITY Equinox 66:1093684036
      ignore, player, flag_and_id = incoming.split
      flag, id = flag_and_id.split(':')
      abunt = game.ability_used_no_target(player, flag, id)
      broadcast(game, :event => 'hero selected', :player => player, :hero => abunt) unless abunt.nil?
    end
    
    def handle_chat(game, incoming)
      # player chat
      # CHAT 1 Equinox -wtf
      ignore, type, player, chat = incoming.split(' ', 4)
      case type.to_i
        when 1 then broadcast(game, :event => 'all chat',   :player => player, :chat => chat)
        when 2 then broadcast(game, :event => 'team chat',  :player => player, :chat => chat)
        when 3 then broadcast(game, :event => 'lobby chat', :player => player, :chat => chat)
      end
    end
    
    def handle_create(game, incoming)
      # new game created
      # CREATE [30]testdota test
      game.name = incoming.sub(/CREATE /i, '')
      broadcast(game, :event => 'game created') unless game.host.nil?
    end
    
    def handle_ended(game, incoming)
      # game is over
      # ENDED
      game.finish!
      broadcast(game, :event => 'game over')
    end
    
    def handle_host(game, incoming)
      # set game host
      # HOST Equinox
      game.host = incoming.split.last
      broadcast(game, :event => 'game created') unless game.name.nil?
    end
    
    def handle_leave(game, incoming)
      # player leaves game
      # LEAVE Equinox
      player = incoming.split.last
      game.players[player][:playing] = false
      broadcast(game, :event => 'player left', :player => player)
    end
    
    def handle_pause(game, incoming)
      # game is paused
      # PAUSE Equinox
      game.pause!
      player = incoming.split.last
      broadcast(game, :event => 'pause', :player => player)
    end
    
    def handle_pjoin(game, incoming)
      # players joins game in lobby
      # PJOIN Equinox
      player = incoming.split.last
      broadcast(game, :event => 'player joined', :player => player)
    end
    
    def handle_pleft(game, incoming)
      # player leaves game in lobby
      # PLEFT Equinox
      player = incoming.split.last
      broadcast(game, :event => 'player left', :player => player)
    end
    
    def handle_plist(game, incoming)
      # incoming list of players
      # PLIST 1.Equinox
      slots_and_names = incoming.split
      slots_and_names.delete_at(0)
      players = {}
      slots_and_names.each do |sn|
        slot, name = sn.split('.')
        players.merge!({ name => { :slot => slot_shift(slot.to_i) } })
      end
      game.players = players
    end
    
    def handle_start(game, incoming)
      # signify game started
      # START
      game.start!
      broadcast(game, :event => 'game started')
    end
    
    def handle_syncs(game, incoming)
      # SyncStoreInteger
      # SYNCS Data CK0D0N0 7
      ignore, key1, key2, value = incoming.split
      key2.downcase!
      h = game.sync_stored_integer(key1, key2, value)
      key2.downcase!
      if    key2 =~ /hero/
        broadcast(game, { :event => 'hero death'  }.merge(h))
      elsif key2 =~ /tower/
        broadcast(game, { :event => 'tower death' }.merge(h))
      elsif key2 =~ /rax/
        broadcast(game, { :event => 'rax death'   }.merge(h))
      elsif key2 =~ /tree/
        nil
      elsif key2 =~ /throne/
        nil
      else
        nil
      end
    end
    
    def handle_unpause(game, incoming)
      # game is unpaused
      # UNPAUSE Equinox
      game.resume!
      player = incoming.split.last
      broadcast(game, :event => 'unpause', :player => player)
    end
    
    def pc(game, player)
      bold colour(player, game.player_colour(player))
    end
    
    def slot_shift(slot)
      case slot
      when 0..4
        slot + 1
      when 5..11
        slot + 2
      else
        puts "Invalid slot: #{slot}"
      end
    end
  end
  
end
