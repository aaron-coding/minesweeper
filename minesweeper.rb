class Board
  
  
  def initialize
    rows = Array.new(9) {[]}
    cols = Array.new(9) {[]}
    
    @board = rows.each_index do |row_idx|
      cols.each_index do |col_idx|
        cols[row_idx] << rows[col_idx]
      end
    end
    
    (0..8).each do |x|
      (0..8).each do |y|
        @board[x][y] = Tile.new(x, y, self)
      end
    end
  end
  
  def render
    @board.each do |col|
      col.each do |tile|
        tile.inspect
      end
    end       
    
  end
  
  def pos(row, col)
    @board[row][col]
  end
  
  def pos=(row, col, tile)
    @board[row][col] = tile
  end
  
  
  
end

class Tile
  attr_reader :bombed
  def initialize(y, x, board_obj)
    @pos = [y,x]
    @bombed = false
    @flagged = false
    @revealed = false
    @board_obj = board_obj
  end
  
  def bombed?
    bombed
  end
  
  def bomb
    @bombed = true
  end
  
  def reveal
    @revealed = true
    if neighbor_bomb_count > 1
    end
  end
  
  def neighbors
    @NEIGHBORS = [[0,-1], [1,-1], [1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1]]
    neighbors = []
    @NEIGHBORS.each do |delta|
      y, x = @pos[0] + delta[0], @pos[1] + delta[1]
      neighbors << @board_obj.pos(y, x) if [x, y].all? {|el| el >= 0 && el <= 8}
    end
    neighbors
  end

  def neighbor_bomb_count
    n_array = self.neighbors
    bomb_count = 0
    n_array.each do |tile|
      bomb_count += 1 if tile.bombed?
    end
    bomb_count
  end
  
  def flag
    @flagged = true
  end
  
  def inspect
    return "F" if @flagged
    return "*" unless @revealed
    return "_" #unless 

#    return
  end
  
end