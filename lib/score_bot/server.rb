require 'gserver'

module ScoreBot
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
