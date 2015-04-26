require './game_of_life.rb'

# Sample run 1 - 1 iteration
@base = [[0,1,0], [1,0,1], [1,1,1]]
gol = GameOfLife.new(@base)
p "After one Iteration"
p gol.run_game(1)
 
# Sample run 2 - 3 iterations (Note: for now only the final output shows up here. This can be run like a loop to see each iterations output.
@base = [[0,1,0], [1,0,1], [1,1,1]]
gol = GameOfLife.new(@base)
p "After 3 Iterations"
p gol.run_game(3)


