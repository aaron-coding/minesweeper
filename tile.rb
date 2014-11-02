require 'colorize'
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
  
  def calc_number_and_color
    if @revealed && neighbor_bomb_count > 0
      case neighbor_bomb_count 
      when 1
        " 1 ".blue
      when 2
        " 2 ".yellow
      when 3
        " 3 ".red
      when 4
        " 4 ".green
      else
        " neighbor_bomb_count ".black
      end
    end
  end
  
  def flag
    @flagged = true
  end
  
  def selected?
    @board.pointer_pos == @pos
    
  end
  def display
     if selected? && !@board.lost?
       tile_value.on_light_white
     else
       tile_value
     end
  end
  
  def tile_value
    return " F " if @flagged && !@revealed #can't flag own bombs
    return " * ".on_light_black unless @revealed || @board.lost? #when game is over, reveal all
    return " B ".red if @bombed
    return "   " if (@revealed && neighbor_bomb_count == 0) || @board.lost?
    return calc_number_and_color  #tile is revealed and must show number
  end
  
  def inspect
   
  end
end
