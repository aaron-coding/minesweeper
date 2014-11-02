require_relative 'board'
require_relative 'tile'
require 'yaml'

class Game
  def initialize(rows = 9, cols = 9, num_bombs = 10) 
    @board = Board.new(rows, cols, num_bombs)
  end
  
  def start 
    @board.print_instructions
    until @board.lost? || @board.won?
      @board.render
      @board.get_move
    end
    end_message
  end

  # def get_action
  #   puts "Do you want to reveal(R), flag(F), save(S), or load(L)?"
  #   action = gets.chomp
  #   until ["R","F","S","L"].include?(action.upcase)
  #     puts "Invalid Entry. Try Again."
  #     action = gets.chomp
  #   end
  #   if action.upcase == "S"
  #     save
  #   elsif action.upcase == "L"
  #     load
  #   end
  #   action.upcase
  # end
  
  def end_message
    if @board.won?
      puts "You won!"
    elsif @board.lost?
      @board.render
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

if __FILE__ == $PROGRAM_NAME
    game = Game.new(9, 9, 10)
    game.start
end
      