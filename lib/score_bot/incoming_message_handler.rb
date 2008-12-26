module ScoreBot  
  module IncomingMessageHandler
    def handle_incoming_line(game, incoming)
      split = incoming.split
      return if split.empty?
      puts "#{game.name || 'UNKNOWN'}\t#{incoming}"
      send("handle_#{split.first.downcase}", game, incoming)
    end
    
    protected
    
    def handle_ability(game, incoming)
      # ability used with no target
      # ABILITY Equinox 66:1093684036
      ability, player, flag_and_id = incoming.split
      flag, id = flag_and_id.split(':')
      game.ability_used_no_target(player, flag, id)
    end
    
    def handle_chat(game, incoming)
      # player chat
      # CHATCMD Equinox -wtf
      # ...
    end
    
    def handle_create(game, incoming)
      # new game created
      # CREATE [30]testdota test
      game.name = incoming.sub('CREATE ', '')
    end
    
    def handle_ended(game, incoming)
      # game is over
      # ENDED
      game.finish!
    end
    
    def handle_host(game, incoming)
      # set game host
      # HOST Equinox
      game.host = incoming.split.last
    end
    
    def handle_leave(game, incoming)
      # player leaves game
      # LEAVE Equinox
      game.players[incoming.split.last][:playing] = false
    end
    
    def handle_pause(game, incoming)
      # game is paused
      # PAUSE Equinox
      game.pause!
    end
    
    def handle_pjoin(game, incoming)
      # players joins game in lobby
      # PJOIN Equinox
    end
    
    def handle_pleft(game, incoming)
      # player leaves game in lobby
      # PLEFT Equinox
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
    end
    
    def handle_syncs(game, incoming)
      # SyncStoreInteger
      # SYNCS Data CK0D0N0 7
      syncs, key1, key2, value = incoming.split
      game.sync_stored_integer(key1, key2, value)
    end
    
    def handle_unpause(game, incoming)
      # game is unpaused
      # UNPAUSE Equinox
      game.resume!
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
