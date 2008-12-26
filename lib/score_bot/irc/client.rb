module ScoreBot
  module IRC
    # Ruby-IRC is a very bad library, so this is about as pretty as it can be made
    # still, better than dealing with it by hand - that isn't the scorebot's purpose
    
    class Client
      include Callbacks
      include Commands
      include Messages
      
      attr_accessor :home
      
      def initialize(server="za.shadowfire.org", port=6667, nick="dotacw", realname="dotacw", home="#clanwar")
        @connection = ::IRC.new(nick, server, port, realname) # bad library requires unscoping :/
        @home = home
        setup_callbacks if self.respond_to? 'setup_callbacks'
      end
      
      def connect!
        @thread = Thread.new do
          begin
            @connection.connect
          rescue Exception => e
            puts e
          end
        end
        
        @msgloop = Thread.new do
          begin
            message_send_loop if self.respond_to? 'message_send_loop'
          rescue Exception => e
            puts e
          end
        end
      end
            
      def join
        @thread.join
        @msgloop.join
      end
    end # client class
    
  end
end
