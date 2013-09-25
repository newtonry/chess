require "./board.rb"
require "./pieces.rb"

class Chess
  def initialize
    @board = Board.new
  end

  def play
    @board.setup_pieces
    turn = [:white, :black]

    loop do
      @board.print_board
      puts

      puts "#{turn.first.to_s.capitalize}'s turn!"
      
      move = prompt_user_for_move

      if @board.is_valid_move?(move[0], move[1], turn.first)

        @board.make_move(move[0], move[1])
        turn.reverse!
      end
    end
  end

  def prompt_user_for_move
    puts "Please enter the next move (e.g. 0,1 2,0)"
    sanitize_input(gets.chomp)
  end

  def sanitize_input input
    start_pos = input.split(" ")[0].split(',').map {|num| num.to_i}
    end_pos = input.split(" ")[1].split(',').map {|num| num.to_i}
    [start_pos, end_pos]
  end
end




 # b = Board.new()
#k = King.new
# kn = Knight.new
 # r = Rook.new(:white)
 # p r.color
# bish = Bishop.new
# q = Queen.new
# pawn = Pawn.new

#b.board[3][3] = pawn


#pawn.position = [3,3]

#p p.move_dirs
# p bish.possible_moves
#p k.possible_moves
#b.setup_pieces
#b.print_board
#b.print_board

# pawn.possible_moves.each do |move|
#   b.board[move[0]][move[1]] = Pawn.new
# end

# b.setup_pieces
# b.print_board
#
# b.make_move([0,1],[2,0])
# puts
# puts
# b.print_board

 # b = Board.new
# b.print_board
#
 # c = b.deep_dup
# c.board[3][3] = k
#
# b.print_board
# c.setup_pieces
# c.print_board


#
 game = Chess.new
 game.play



#p get_direction([0,0], [0,5])

