module ScoreBot
  module IRC
  
    module Decorations
      def bold(text)
        "\02#{text}\02"
      end
      
      def colour(text, foreground, background=nil)
        "\03#{colour_code_for(foreground, background)}#{text}\03"
      end
      
      COLOUR_MAP = {
       :white   => "00",
       :black   => "01",
       :blue    => "02", # navy
       :green   => "03",
       :red     => "04",
       :brown   => "05", # maroon
       :purple  => "06",
       :orange  => "07", # olive
       :yellow  => "08",
       :lime    => "09", # light green
       :teal    => "10", # green/blue cyan
       :aqua    => "11", # light cyan
       :royal   => "12", # light blue
       :fuchsia => "13", # light purple
       :grey    => "14",
       :silver  => "15"  # light grey
      }

      def colour_code_for(foreground, background=nil)
        bgcode = background.nil? ? "99" : COLOUR_MAP[foreground]
        %w(COLOUR_MAP[foreground] , bgcode).join
      end
    end
    
  end
end
