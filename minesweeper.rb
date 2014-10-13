require 'yaml'

class Game
  def initialize 
    @board = Board.new
  end

  def start
    puts "Welcome to your worst enemy in hell: Minesweeper"
    loop do
      @board.render
      puts "Do you want to reveal(R), flag(F), save(S), or load(L)?"
      action = gets.chomp
      unless ["R","F","S","L"].include?(action.upcase)
        puts "Invalid Entry"
        next
      end
      if action.upcase == "S"
        save
        break
      elsif action.upcase == "L"
        load
        break
      end
      
      puts "On which square (row, col)? Separate with comma."
      square_coords = gets.chomp.split(',')
      if action.upcase == "R"
        @board.pos(square_coords[0].to_i, square_coords[1].to_i).reveal
      elsif action.upcase == "F"
        @board.pos(square_coords[0].to_i, square_coords[1].to_i).flag
      end
      break if @board.lost? || @board.won?
    end
    if @board.won?
      puts "You won!"
    elsif @board.lost?
      puts "You lost :("
    else
      puts "See you soon.... Enjoy living for now." 
    end
  end
  
  
  def save
    File.open('saved-game.txt', 'w') do |f|
      f.puts @board.to_yaml
    end
  end
  
  def load
    puts "Loading file"
    @board = YAML.load_file('saved-game.txt') 
  end
        


  
end

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
        @board[y][x] = Tile.new(y, x, self)
      end
    end
    
    bomb_coords = []
    loop do  
      y, x = rand(9), rand(9)
      if !bomb_coords.include?([y,x])
        bomb_coords << [y,x]
        @board[y][x].bomb
      end
      break if bomb_coords.length == 10
    end
    
    @over = false
    
  end
  
  def render
    @board.each do |col|
      row = []
      col.each do |tile|
        row << tile
      end
      p row
    end       
    
  end
  
  def pos(row, col)
    @board[row][col]
  end
  
  def pos=(row, col, tile)
    @board[row][col] = tile
  end
  
  def over
    @over = true
  end
  
  def lost?
    @over
  end
  
  def won?
    unrevealed_tiles = 0
    (0..8).each do |x|
      (0..8).each do |y|
        unrevealed_tiles += 1 if !(@board[y][x].revealed)
      end
    end
    unrevealed_tiles == 10
  end
  
end

class Tile
  attr_reader :bombed, :revealed
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
    
    unless @flagged
      @revealed = true 
      if bombed?
        @board_obj.over
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
    @DELTAS = [[0,-1], [1,-1], [1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1]]
    @neighbors = []
    @DELTAS.each do |delta|
      y, x = @pos[0] + delta[0], @pos[1] + delta[1]
      @neighbors << @board_obj.pos(y, x) if [x, y].all? {|el| el >= 0 && el <= 8}
    end
    @neighbors
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
    return "B" if @bombed
    return "_" if @revealed && neighbor_bomb_count == 0
    return "#{neighbor_bomb_count}" if @revealed && neighbor_bomb_count > 0

  end
  
end