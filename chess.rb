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
        if @board.checkmate?(turn[0])
          puts "Checkmate! #{turn.first.to_s.capitalize} loses!"
          return
        end
      else
        puts "Not a valid move"
      end
    end
  end

  def prompt_user_for_move
    print "Please enter the next move (e.g. a2 a3): "
    sanitize_input(gets)
  end

  def sanitize_input input
    input = input.strip.upcase
    start_pos, end_pos = *input.split

    start_pos = start_pos.each_char.to_a
    start_pos = [start_pos[1].to_i - 1, start_pos[0].ord - "A".ord]
    end_pos = end_pos.each_char.to_a
    end_pos = [end_pos[1].to_i - 1, end_pos[0].ord - "A".ord]

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

