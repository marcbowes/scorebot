module ScoreBot
  module Game
  
    class Util
      def self.ability_to_hero_name(ability)
        # a version of this is saved for safety sake
        begin
          @@hero_list ||= open("http://dev.agasa.co.za/HEROLIST.txt").read
        rescue Exception => e
          @@hero_list = open("lib/score_bot/HEROLIST.txt").read
        end
        @@hero_list.each_line do |line|
          if line.match ability
            return line.split(":")[1].sub(' \'', '')
          end
        end
        nil
      end
    end
    
  end
end
