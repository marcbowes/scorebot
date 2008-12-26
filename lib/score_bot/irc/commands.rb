module ScoreBot
  module IRC
  
    module Commands
      def self.included(client)
        client.class_eval do
          def command_before_filter(from, text)
            return unless text =~ /^\./
            text.downcase!
            command = text.split.first.delete('.')
            if self.respond_to? "command_#{command}"
              text = text.sub(command, '')
              send("command_#{command}", from, text)
            else
              send_channel_message(@home, "invalid command - #{command}")
            end
          end
          
          def command_quit(from, text)
            @connection.send_quit
            IRCConnection.quit
            exit(0)
          end
        end
      end
    end
    
  end
end
