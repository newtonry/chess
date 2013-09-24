require "./pieces.rb"

class Chess
  def initialize
    @board = Board.new
  end

  def play
    @board.setup_pieces

    loop do
      @board.print_board
      puts

      move = prompt_user_for_move
      @board.make_move(move[0], move[1])
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

class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) {[nil] * 8}
  end

  #sets up pieces in new starting position
  def setup_pieces
    pieces = []

    pieces << Rook.new << Knight.new << Bishop.new << Queen.new
    pieces << King.new << Bishop.new << Knight.new << Rook.new
    pawns = []

    8.times do |x|
      pawns << Pawn.new
    end

    fill_row(0, pieces)
    fill_row(1, pawns)
  end

  def fill_row row_ind, pieces
    @board[row_ind].each_with_index do |square, ind|
      @board[row_ind][ind] = pieces.shift
      @board[row_ind][ind].set_position([row_ind, ind])
    end
  end

  def make_move start_pos, end_pos
    #have to validate the moves
    @board[end_pos[0]][end_pos[1]] = @board[start_pos[0]][start_pos[1]]
    @board[start_pos[0]][start_pos[1]].move_piece(end_pos)
    @board[start_pos[0]][start_pos[1]] = nil
  end

  #sees if the given color's king is in check
  def check? color
  end

  #sees if game is over
  def checkmate?
  end

  #duplicates board so that we can test moves
  def dup
  end

  def print_board
    piece_set = get_visual_pieces
    #NOTICE THAT THE BOARD IS REVERSED HERE, LOOKING FROM WHITE'S POV
    counter = 7 #get rid of this later, use a diff method. purpose is to list rows

    @board.reverse.each_with_index do |row, ind|
      row_output = ''
      row.each do |piece|
        row_output << '|'
        if piece.nil?
          row_output << ' '
        else
          row_output << piece_set[piece.class.to_s.downcase.to_sym]
        end
      end
      p "#{counter} " << row_output << "|"
      counter -= 1
    end

    p "   " << (0..7).to_a.join(" ")
  end

  def get_visual_pieces
    white_unicode = {
      :king => "\u2654",
      :queen => "\u2655",
      :rook => "\u2656",
      :bishop => "\u2657",
      :knight => "\u2658",
      :pawn => "\u2659"
    }

    black_unicode = {
      :king => "\u265A",
      :queen => "\u265B",
      :rook => "\u265C",
      :bishop => "\u265D",
      :knight => "\u265E",
      :pawn => "\u265F"
    }

    white_unicode
  end
end



# b = Board.new()
# k = King.new
# kn = Knight.new
# r = Rook.new
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

game = Chess.new
game.play
