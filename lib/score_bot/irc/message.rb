module ScoreBot
  module IRC
    
    class Message
      attr_accessor :type, :to, :content
      
      def initialize(attributes={})
        self.attributes = attributes
      end
      
      def attributes=(new_attributes)
        attributes = new_attributes.dup
        attributes.keys.each do |key| # this is ActiveSupport/Hash.stringify_keys!
          attributes[key.to_s] = attributes.delete(key)
        end
        attributes.each { |k, v| send(k + "=", v) }
      end
    end
  
  end
end
