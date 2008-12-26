module ScoreBot
  module IRC
    
    class Message
      attr_accessor :type, :to, :content
      
      def initialize(attributes={})
        self.attributes = attributes
      end
      
      def attributes=(new_attributes)
        attributes = new_attributes.dup
        attributes.stringify_keys!
        attributes.each { |k, v| send(k + "=", v) }
      end
    end
  
  end
end
