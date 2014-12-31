require_relative 'pretty_print'

module RobotNavigator
  class Commander
    include PrettyPrint
    
    attr_accessor :robot, :table, :operator, :args, :command, :output_message, :output_type, :show_output
    @@commands = [:move, :place, :left, :right, :rotate, :report]
  
    def initialize(robot, table, show_output)
      @robot = robot
      @table = table
      @show_output = show_output
    end
  
    # Clears the output variables of the previous command.
    # parses the current command, runs if if valid and displays the output
    def execute(input_command)
      reset_ouput_variables
      parse_command(input_command)
      
      self.send(@command) if valid_command?
      
      display_output if @show_output
    end
  
    private
  
    # Rotates the robot to left if placed on table
    def left
      @robot.rotate_left if robot_placed_on_table?
    end

    # Moves the robot by one step if it is safe. 
    # Else ignored with a warning.
    def move
      return unless robot_placed_on_table?
      
      unless @table.place_robot!(next_position_to_be_moved)
        @output_message, @output_type = "The Robot is on the edge. This is not a safe move! Ignoring #{@operator}", :warning
      end
    end

    def place
      begin
        tokens = @args.split(/,/).map(&:strip)
        x, y, direction = tokens[0].to_i, tokens[1].to_i, tokens[2].downcase.to_sym
        
        unless @robot.set_direction(direction) && @table.place_robot!({:x => x, :y => y})
          @output_message, @output_type = "Can't place the robot on the table. Invalid arguments.", :error
        end
      rescue Exception
        
        # Catching all the exceptions in generic way for now. 
        # Invalid arguments can only cause the exceptions but nothing else really.
        @output_message, @output_type = "Can't place the robot on the table. Invalid arguments.", :error
      end
    end

    # Initializes out put variables with current position and direction of the robot.
    def report
      return unless robot_placed_on_table?
      
      position = @table.robot_position
      direction = @robot.direction
      
      @output_message, @output_type = "#{position[:x]},#{position[:y]},#{direction.to_s.upcase}", :success
    end

    # Rotates the robot to right if placed on table
    def right
      @robot.rotate_right if robot_placed_on_table?
    end
  
    def display_output
      pretty_print(@output_message, @output_type)
    end
  
    def valid_command?
      if @@commands.include?(@command)
        true
      else
        @output_message, @output_type = "Invalid command #{@operator}", :error
        false
      end
    end
  
    def robot_placed_on_table?
      unless @table.robot_placed?
        @output_message, @output_type = "The Robot is not placed on the table yet. Ignoring #{@operator}", :warning
      end
      @table.robot_placed?
    end
  
    def reset_ouput_variables
      @output_message, @output_type = nil
    end
  
    #Parses the command string and initializes the needed instance variables.
    def parse_command(cmd)
      tokens = cmd.split(/\s+/, 2)
      @operator, @args = [tokens.first, tokens.last]
      @command = @operator.downcase.to_sym
    end
    
    # Finds the next position of the robot based on it's current position and direction 
    # and returns it as a hash of :x and :y keys. 
    # Ex - {:x => 1, :y =? 2}
    def next_position_to_be_moved
      move_diff = @robot.next_move_difference
      current_pos = @table.robot_position
      {:x => current_pos[:x] + move_diff[:x], :y => current_pos[:y] + move_diff[:y]}
    end
  end
end