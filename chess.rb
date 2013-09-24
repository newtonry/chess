require "./pieces.rb"

class ChessGame
  def initialize
  end

  def play
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

    @board.each_with_index do |row, row_ind|
      row.each_with_index do |column, col_ind|



        @board[row_ind][col_ind] = pieces.shift

#        @board[row_ind][col_ind].set_position([row_ind][col_ind])
      end
    end
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
    @board.reverse.each do |row|
      row_output = ''
      row.each do |piece|
        row_output << '|'
        if piece.nil?
          row_output << ' '
        else
          row_output << piece_set[piece.class.to_s.downcase.to_sym]
        end
      end
      p row_output << "|"
    end
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



b = Board.new()
k = King.new

b.board[0][0] = k


k.position = [3,3]

p k.possible_moves


#b.setup_pieces
b.print_board
