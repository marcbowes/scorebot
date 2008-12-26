module ScoreBot

  module IncomingMessageHandler
    include ScoreBot::IRC::Decorations
    
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
      ignore, player, flag_and_id = incoming.split
      flag, id = flag_and_id.split(':')
      abunt = game.ability_used_no_target(player, flag, id)
      broadcast(game, :event => 'hero selected', :player => player, :hero => abunt)
    end
    
    def handle_chat(game, incoming)
      # player chat
      # CHAT 1 Equinox -wtf
      ignore, type, chat = incoming.split(' ', 3)
      case type.to_i
        when 1 then broadcast(game, player, :event => 'all chat',   :player => player, :chat => chat)
        when 2 then broadcast(game, player, :event => 'team chat',  :player => player, :chat => chat)
        when 3 then broadcast(game, player, :event => 'lobby chat', :player => player, :chat => chat)
      end
    end
    
    def handle_create(game, incoming)
      # new game created
      # CREATE [30]testdota test
      game.name = incoming.sub('CREATE ', '')
      broadcast(game, :event => 'game created', :name => game.name, :host => game.host) unless if game.host.nil?
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
      broadcast(game, :event => 'game created', :name => game.name, :host => game.host) unless if game.name.nil?
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
      broadcast(game, :event => 'is paused', :player => player)
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
      game.sync_stored_integer(key1, key2, value)
    end
    
    def handle_unpause(game, incoming)
      # game is unpaused
      # UNPAUSE Equinox
      game.resume!
      player = incoming.split.last
      broadcast(game, :event => 'is unpaused', :player => player)
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
