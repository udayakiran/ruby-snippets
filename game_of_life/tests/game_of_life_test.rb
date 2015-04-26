# This is the unit test file with basic test cases for RestaurantFinder.
# == To run
# - Go to the directory which has this script and type
#    ruby game_of_life_test.rb
# Only very basic and happy paths are covered.

require 'test/unit'
require '../game_of_life'

class GameOfLifeTest < Test::Unit::TestCase

  
    def setup
     @sample_input = [[0,1,0], [1,0,1], [1,1,1]]
     @gol = GameOfLife.new(@sample_input)
    end
    
    def test_one_iteraration
      @expected_output = [[0, 1, 0], [1, 0, 1], [1, 0, 1]]
      assert_equal  @expected_output, @gol.run_game(1) 
    end
    
    def test_multiple_iterations
      @sample_input = [[0,1,0], [1,0,1], [1,1,1]]
      @expected_output = [[0, 1, 0], [1, 0, 1], [0, 1, 1]]
      assert_equal  @expected_output, @gol.run_game(5) 
    end

    def test_neighbours
      assert_equal [1, 0, 1, 1, 1], @gol.neighbours(2,1) #all neighbours of the cell on the first run as per sample input
    end
    
    def test_alive_neighbours
      assert_equal [1, 1, 1, 1], @gol.alive_neighbours(2,1) #alive neighbours of the cell on the first run as per sample input

    end
end
