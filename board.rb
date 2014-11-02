require 'io/console'
class Board
  attr_reader :pointer_pos
  def initialize(rows = 9, cols = 9, num_bombs = 10)
    @board = Array.new(rows) { Array.new(cols) }
    make_blank_tiles(rows, cols)
    place_bombs(rows, cols, num_bombs)
    @over = false
    @pointer_pos = [0, 0]
  end
  
  def make_blank_tiles(rows, cols)
    (0..(rows - 1)).each do |x|
      (0..(cols - 1)).each do |y|
        @board[y][x] = Tile.new(y, x, self)
      end
    end
  end
  
  def place_bombs(rows, cols, num)
    bomb_coords = []
    loop do  
      y, x = rand(rows), rand(cols)
      if !bomb_coords.include?([y,x])
        bomb_coords << [y,x]
        @board[y][x].bomb
      end
      break if bomb_coords.length == num
    end
  end
  
  def get_move
    done = false
    until done
      input = STDIN.getch
      if input == "\e" #Handle arrow keys
        STDIN.getch #skip "[" char as it is shared by all arrows
        case STDIN.getch
        when "A"
          @pointer_pos[0] -= 1
        when "C"
          @pointer_pos[1] += 1 
        when "B"
          @pointer_pos[0] += 1
        when "D"
           @pointer_pos[1] -= 1
        end
        system("clear")
        render
      else
        case input #Navigation is also possible with "WASD"
        when "w" || "\e[A"
          @pointer_pos[0] -= 1
        when "a" || "\e[D"
          @pointer_pos[1] -= 1
        when "s" || "\e[B"
          @pointer_pos[0] += 1  
        when "d"
          @pointer_pos[1] += 1 
        when "f" #flag
          done = true
          pos(@pointer_pos[0], @pointer_pos[1]).flag
        when "r" #reveal
          done = true
          pos(@pointer_pos[0], @pointer_pos[1]).reveal
        when "i"
          print_instructions
        end
        system("clear")
        render if !done
      end
    end

  end
  
  def print_instructions
    puts "Welcome to your worst enemy: Minesweeper"
    puts "Use the Arrow Keys or WASD keys to move."
    puts "Type R to reveal, or F to flag, I to repeat instructions"
  end
  def render
    @board.each_with_index do |col, c_idx|
      row = []
      col.each_with_index do |tile, t_idx|
        print tile.display
      end
      puts "\n"
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