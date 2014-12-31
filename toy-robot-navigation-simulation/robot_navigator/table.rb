module RobotNavigator
  class Table

    attr_accessor :robot_position, :rows, :cols

    def initialize(rows, cols)
      @rows = rows
      @cols = cols
    end

    # Changes the robots position only if the arguments passed are safe so that robot 
    # does not go off the table.
    # Arguments: Hash with :x and :y keys and values are positions where robot need to be placed.
    # Ex - place_robot!({:x => 1, y => 2})
    def place_robot!(pos)
      self.robot_position = pos if safe_position?(pos) 
    end

    def robot_placed?
      self.robot_position != nil
    end

    private

    # returns true if coordinates of the robot do not cross over that of the table.
    # false otherwise.
    # Arguments: Hash with :x and :y keys and values are positions where robot need to be placed.
    # Ex - safe_position?({:x => 1, y => 2})
    def safe_position?(pos)
      (pos[:x] >= 0 && pos[:x] < rows && pos[:y] >= 0 && pos[:y] < cols)
    end
  end
end
