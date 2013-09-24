require "./pieces.rb"

class ChessGame
  def initialize
  end

  def play
  end

end

class Board
  def initialize
    @board = Array.new(8) {[nil] * 8}
  end

  #sets up pieces in new starting position
  def setup_pieces
    pieces = []

    pieces << Rook.new << Knight.new << Bishop.new << Queen.new
    pieces King.new << Bishop.new << Knight.new << Rook.new

    @board.with_index do |row, row_ind|
      row.each_with_index do |column, col_ind|
        @board[row_ind][col_ind] = pieces[col_ind]
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
    #NOTICE THAT THE BOARD IS REVERSED HERE, LOOKING FROM WHITE'S POV
    @board.reverse.each do |row|
      row_output = ''
      row.each do |piece|
        row_output << '|'
        row_output << ' ' if piece.nil?
      end
      p row_output << "|"
    end
  end
end



b = Board.new()
b.setup_pieces
b.print_board
