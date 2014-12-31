require_relative 'directions'

module RobotNavigator
  class Robot
    include RobotNavigator::Directions
    
    attr_accessor :direction

    def rotate_left
      self.direction = left_of(self.direction)
    end
    
    def set_direction(direction)
      self.direction = direction if directions.include?(direction)
    end

    def rotate_right
      self.direction = right_of(self.direction)
    end

    # Returns the difference along x and y coordinates as a Hash when next MOVE command is 
    # executed.
    # Ex - When Robot is facing EAST executing MOVE command does not change it's coordinate along x
    # but increases the coordinate along y by 1. In this case the return value of this method
    # will be {:x => 0, :y => 1}
    def next_move_difference
      step_difference_along_direction(self.direction)
    end
  end
end
