class Tile
  DELTAS = [[0,-1], [1,-1], [1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1]]
  
  attr_reader :bombed, :revealed
  
  def initialize(y, x, board)
    @pos = [y,x]
    @bombed = false
    @flagged = false
    @revealed = false
    @board = board
  end
  
  def bombed?
    bombed
  end
  
  def bomb
    @bombed = true
  end
  
  def reveal
    unless @revealed || @flagged
      @revealed = true 
      if bombed?
        @board.over
      elsif neighbor_bomb_count == 0
        @neighbors.each do |neighbor|
          if !(neighbor.revealed) 
            neighbor.reveal 
          end
        end  
      end
    end
    
  end
  
  def neighbors
    @neighbors = []
    DELTAS.each do |delta|
      y, x = @pos[0] + delta[0], @pos[1] + delta[1]
      @neighbors << @board.pos(y, x) if [x, y].all? {|el| el >= 0 && el <= 8}
    end
    @neighbors
  end

  def neighbor_bomb_count
    n_array = self.neighbors
    n_array.count { |tile| tile.bombed? }
  end
  
  def flag
    @flagged = true
  end
  
  def inspect
    return "F" if @flagged
    return "*" unless @revealed || @board.lost?
    return "B" if @bombed
    return "_" if (@revealed && neighbor_bomb_count == 0) || @board.lost?
    return "#{neighbor_bomb_count}" if @revealed && neighbor_bomb_count > 0
  end
end