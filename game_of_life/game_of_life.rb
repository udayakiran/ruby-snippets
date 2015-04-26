class GameOfLife
  attr_accessor :base, :next, :size
  
  def initialize(base_matrix)
    @current_state = base_matrix
    @size = @current_state.size
    @next_state = Array.new
    @size.times do |i| @next_state << [] end
  end
  
  def alive_neighbours(x,y)
    neighbours(x,y).select {|st| st == 1}
  end

  def neighbours(x, y)
    # (x-1, y-1), (x-1, y), (x-1, y+1), (x, y-1), (x,y+1), (x+1, y-1), (x+1, y), (x+1, y+1)
    (-1..1).collect do |r| 
      (-1..1).collect do |c|
        next if (r==0 && c== 0) || (x+r < 0 || y+c < 0)
        @current_state[x+r] && @current_state[x+r][y+c]
      end.compact
    end.compact.flatten
  end

  def next_state_of_cell(x,y)
    alive_count = alive_neighbours(x,y).size
    current_state = @current_state[x][y].to_i
    
    if current_state == 1
     [2,3].include?(alive_count) ? 1 : 0
    else
      (current_state == 0 && alive_count == 3) ? 1 : current_state
    end 
  end
  
  def run_game(iters)
    iters.times do |i|
      @current_state.each_index do |x|
        @current_state[x].each_index do |y|
          @next_state[x][y] = next_state_of_cell(x,y)
        end
      end
      @current_state = @next_state
    end
    @current_state
  end

end
