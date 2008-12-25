module ScoreBot
  module IncomingMessageHandler
    def handle_incoming_line(game, incoming)
      case incoming.split.first.downcase
          # 1. description
          # 2. example
        when 'ability'
          # ability used with no target
          # ABILITY Equinox 66:1093684036
          player, flag, id = extract_ability_information(incoming)
          game.ability_used_no_target(player, flag, id)
        when 'chat'
          # player chat
          # CHATCMD Equinox -wtf
          # ...
        when 'create'
          # new game created
          # CREATE [30]testdota test
          game.name = extract_name(incoming)
        when 'ended'
          # game is over
          # ENDED
          game.finish!
        when 'host'
          # set game host
          # HOST Equinox
          game.host = extract_host(incoming)
        when 'pause'
          # game is paused
          # PAUSE Equinox
          game.pause!
        when 'plist'
          # incoming list of players
          # PLIST 1.Equinox
          game.players = extract_players(incoming)
        when 'start'
          # signify game started
          # START
          game.start!
        when 'unpause'
          # game is unpaused
          # UNPAUSE Equinox
          game.resume!
        else
          # unknown message
      end
    end
    
    protected
    
    def extract_ability_information(incoming)
      # ABILITY Equinox 66:1093684036
      ability, name, flag_and_id = incoming.split
      flag, id = flag_and_id.split(':')
      return name, flag.to_i, id.to_i
    end
    
    def extract_host(incoming)
      # HOST Equinox
      incoming.split.last
    end
    
    def extract_name(incoming)
      # CREATE [30]testdota test
      incoming.sub 'CREATE ', ''
    end
    
    def extract_players(incoming)
      # PLIST 1.Equinox
      slots_and_names = incoming.split
      slots_and_names.delete_at(0)
      players = {}
      slots_and_names.each do |sn|
        slot, name = sn.split('.')
        players.merge!({ slot.to_i => name })
      end
      return players
    end
  end
end
