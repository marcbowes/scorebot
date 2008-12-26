require 'gserver'

module ScoreBot  
  class Server < GServer
    include IncomingMessageHandler
    
    def initialize(port=6110, host="0.0.0.0", *args)
      super(port, host, *args)
    end
    
    def serve(io)
      game = Game::Instance.new
      loop do
        if IO.select([io], nil, nil, 2)
          begin
            buf = io.gets
            io.close and return if buf.nil?
            handle_incoming_line(game, buf.chomp)
          rescue Exception => e
            puts e
          end
        end
        break if io.closed?
      end
    end
  end
end
