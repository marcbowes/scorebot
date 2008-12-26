module ScoreBot
  module IRC
  
    module Messages
      def self.included(client)
        client.class_eval do
          def enqueue(message)
            @mutex.synchronize do
              @messages << message unless message.nil? 
              @wait.signal
            end
          end

          def send_channel_message(channel, message)
            enqueue(Message.new(:type => "message", :to => channel, :content => message))
          end

          def send_channel_notice(channel, message)
            enqueue(Message.new(:type => "notice", :to => channel, :content => message))
          end

          def send_private_message(to, message)
            enqueue(Message.new(:type => "message", :to => to, :content => message))
          end

          def send_private_notice(to, message)
            enqueue(Message.new(:type => "notice", :to => to, :content => message))
          end
          
          def message_send_loop
            @mutex    = Mutex.new
            @wait     = ConditionVariable.new
            @messages = []
            loop do
              @mutex.synchronize do
                @message = @messages.first
                if @message.nil?
                  @wait.wait(@mutex) 
                  @message = @messages.first
                end
                break if @message.nil? # connection broken
                @messages.delete(@message)
              end
              
              case @message.type
                when "message" then @irc.send_message @message.to, @message.content
                when "notice"  then @irc.send_notice  @message.to, @message.content
              end
              
              sleep(0.5) # anti-flood
            end
          end
        end
      end # self.included
    end # messages module
    
  end
end
