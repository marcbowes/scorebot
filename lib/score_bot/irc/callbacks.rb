module ScoreBot
  module IRC
  
    module Callbacks  
      def self.included(client)
        def setup_callbacks
          IRCEvent.add_callback('endofmotd') do |event|
            @connection.add_channel(@home)
          end

          IRCEvent.add_callback('privmsg') do |event|
            case event.channel
            when @connection.nick # private message
              puts "private message (#{event.from}): #{event.message}"
            else                  # channel message
              puts "channel message (#{event.channel}): - #{event.from} - #{event.message}"
            end
            split = event.message.split
            unless split.nil? or split.empty?
              if split.first =~ /^\./
                command_before_filter(event.from, event.message) if self.respond_to? 'commands_enabled?'
              end
            end
          end # privmsg callback
        end
      end # self.included
    end # callbacks module
    
  end
end
