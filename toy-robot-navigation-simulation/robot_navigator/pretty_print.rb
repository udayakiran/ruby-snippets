module RobotNavigator
  module PrettyPrint
    @@output_types = {:error => 31, #color code for red
      :success => 32, #color code for green
      :warning => 33 #color code for yellow
    }
  
    def pretty_print(text, type=nil)
      print (type && @@output_types[type]) ? colorize(text, @@output_types[type]) : text
    end
  
    private
    #returns the passed text interpolated in a string to support color scheme.
    def colorize(text, color_code)
      "\e[#{color_code}m#{text}\e[0m\n"
    end
  end
end