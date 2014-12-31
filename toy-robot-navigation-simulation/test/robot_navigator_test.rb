# This is the unit test file with basic test cases for robot navigator.
# == To run
# - Go to the directory which has this script and type
#    ruby robot_navigator_test.rb
  
# RestaurantFinder#find_best method is tested for various cases. 
# This is the major and most testable method. So, only tests for this are covered.

require 'test/unit'
require_relative '../robot_navigator/navigator'

class RobotNavigatorTest < Test::Unit::TestCase

  def setup
    @navigator = RobotNavigator::Navigator.new(false)
  end
    
  def test_invalid_command
    @navigator.execute("CMD")
    assert_equal "Invalid command CMD", @navigator.commander.output_message
    assert_equal :error, @navigator.commander.output_type
  end

  def test_move_before_place
    @navigator.execute("MOVE")
    assert !@navigator.commander.table.robot_placed?
    assert_equal "The Robot is not placed on the table yet. Ignoring MOVE", @navigator.commander.output_message
    assert_equal :warning, @navigator.commander.output_type
  end

  def test_report_before_place
    @navigator.execute("REPORT")
    assert !@navigator.commander.table.robot_placed?
    assert_equal "The Robot is not placed on the table yet. Ignoring REPORT", @navigator.commander.output_message
    assert_equal :warning, @navigator.commander.output_type
  end
    
  def test_place_success
    @navigator.execute("PLACE 1,2,SOUTH")
    assert @navigator.commander.table.rows > 1
    assert @navigator.commander.table.cols > 1
    assert @navigator.commander.table.robot_placed?
    assert_nil @navigator.commander.output_message
    assert_nil @navigator.commander.output_type
  end
  
  def test_place_command_with_invalid_args
    @navigator.execute("PLACE ME")
    assert !@navigator.commander.table.robot_placed?
    assert_equal "Can't place the robot on the table. Invalid arguments.", @navigator.commander.output_message
    assert_equal :error, @navigator.commander.output_type
  end
  
  def test_place_command_with_invalid_direction
    @navigator.execute("PLACE 1,2,UK")
    assert !@navigator.commander.table.robot_placed?
    assert_nil @navigator.commander.robot.direction
    assert_equal "Can't place the robot on the table. Invalid arguments.", @navigator.commander.output_message
    assert_equal :error, @navigator.commander.output_type
  end
    
  def test_place_command_off_the_table
    @navigator.execute("PLACE 6,2,SOUTH")
    assert @navigator.commander.table.rows < 6
    assert !@navigator.commander.table.robot_placed?
    assert_equal "Can't place the robot on the table. Invalid arguments.", @navigator.commander.output_message
    assert_equal :error, @navigator.commander.output_type
  end

  def test_safe_move
    @navigator.execute("PLACE 0,2,SOUTH")
    @navigator.execute("MOVE")
    @navigator.execute("REPORT")
    assert_equal "0,1,SOUTH", @navigator.commander.output_message
    assert_equal :success, @navigator.commander.output_type
  end

  def test_unsafe_move
    @navigator.execute("PLACE 0,2,SOUTH")
    @navigator.execute("MOVE")
    @navigator.execute("MOVE")
    @navigator.execute("MOVE")
    @navigator.execute("MOVE")
    assert_equal :warning, @navigator.commander.output_type
    @navigator.execute("REPORT")
    assert_equal "0,0,SOUTH", @navigator.commander.output_message
  end
  
  def test_left
    @navigator.execute("PLACE 0,2,SOUTH")
    @navigator.execute("LEFT")
    @navigator.execute("REPORT")
    assert_equal "0,2,EAST", @navigator.commander.output_message
    @navigator.execute("LEFT")
    @navigator.execute("REPORT")
    assert_equal "0,2,NORTH", @navigator.commander.output_message
    @navigator.execute("LEFT")
    @navigator.execute("REPORT")
    assert_equal "0,2,WEST", @navigator.commander.output_message
    @navigator.execute("LEFT")
    @navigator.execute("REPORT")
    assert_equal "0,2,SOUTH", @navigator.commander.output_message
  end
  
  def test_right
    @navigator.execute("PLACE 0,2,SOUTH")
    @navigator.execute("RIGHT")
    @navigator.execute("REPORT")
    assert_equal "0,2,WEST", @navigator.commander.output_message
    @navigator.execute("RIGHT")
    @navigator.execute("REPORT")
    assert_equal "0,2,NORTH", @navigator.commander.output_message
    @navigator.execute("RIGHT")
    @navigator.execute("REPORT")
    assert_equal "0,2,EAST", @navigator.commander.output_message
    @navigator.execute("RIGHT")
    @navigator.execute("REPORT")
    assert_equal "0,2,SOUTH", @navigator.commander.output_message
  end

  def test_report
    @navigator.execute("PLACE 4,4,SOUTH")
    @navigator.execute("REPORT")
    assert_equal "4,4,SOUTH", @navigator.commander.output_message
    assert_equal :success, @navigator.commander.output_type
  end
  
  def test_commands_are_case_insensitive
    @navigator.execute("PlaCe 4,4,SOuth")
    @navigator.execute("RepORt")
    assert_equal "4,4,SOUTH", @navigator.commander.output_message
    assert_equal :success, @navigator.commander.output_type
  end
  
  def test_place_command_ignores_spaces_in_args
    @navigator.execute("PLACE 4,  4,SOUTH  ")
    @navigator.execute("REPORT")
    assert_equal "4,4,SOUTH", @navigator.commander.output_message
    assert_equal :success, @navigator.commander.output_type
  end
end