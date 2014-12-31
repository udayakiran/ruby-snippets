module RobotNavigator
  module Directions
  
    # Hash containing each of the known directions and the directions that are 
    # left and right to them.
    @@directions = { 
      :north => {:left => :west, :right => :east}, 
      :west => {:left => :south, :right => :north}, 
      :south => {:left => :east, :right => :west}, 
      :east => {:left => :north, :right => :south} 
    }
    
    # Hash containing each of the known directions and the horizontal and vertical 
    # shift difference that is caused by MOVE command when robot is facing this direction.
    @@move_difference_along_directions = {
      :north => {:x => 0, :y => 1}, 
      :west => {:x => -1, :y => 0}, 
      :south => {:x => 0, :y => -1}, 
      :east => {:x => 1, :y => 0}  
    }
    
    def directions
      @@directions
    end
   
    def step_difference_along_direction(direction)
      @@move_difference_along_directions[direction]
    end
    
    def right_of(direction)
      @@directions[direction][:right]
    end
    
    def left_of(direction)
      @@directions[direction][:left]
    end
  end
end