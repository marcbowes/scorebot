require 'gserver'

module ScoreBot
  $:.unshift(File.dirname(__FILE__)) unless
    $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  
  require 'incoming_message_interpreter'
  
  include IncomingMessageInterpreter
  
  class Server < GServer
    def initialize(port=6110, host="0.0.0.0", *args)
      super(port, host, *args)
    end
    
    def serve(io)    
      loop do
        if IO.select([io], nil, nil, 2)
          puts "recv: #{io.gets.chomp}"
        end
        break if io.closed?
      end
    end
  end
end
