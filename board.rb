class Board
  attr_accessor :board

  def initialize board_status = nil
    if board_status.nil?
      @board = Array.new(8) {[nil] * 8}
    else
      @board = board_status
    end
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
    piece = @board[start_pos[0]][start_pos[1]]
    @board[end_pos[0]][end_pos[1]] = piece
    piece.move_piece(end_pos)
    @board[start_pos[0]][start_pos[1]] = nil
  end

  def is_valid_move? start_pos, end_pos
    piece = @board[start_pos[0]][start_pos[1]]

    if !piece.possible_moves.include?(end_pos)
      puts "Piece can't move there!!!!!"
      return false
    end

    if piece.is_a?(SlidingPiece)
      direction = get_direction(start_pos, end_pos)
      pos = start_pos.dup

      #incrementally moves pos towards the end_pos
      until pos == end_pos
        pos[0] += direction[0]
        pos[1] += direction[1]

        if !@board[pos[0]][pos[1]].nil? #a piece is in the way!
          puts "Piece can't move there!!!!!"
          return false
        end
      end
    end

    true
  end

  #duplicates board so that we can test moves
  def deep_dup
    duped_board = []
    @board.each_with_index do |row, row_ind|
      duped_board << []

      row.each_with_index do |piece, column_ind|
        if piece.nil?
          duped_board[row_ind][column_ind] = nil
          next
        end

        new_piece = piece.dup
        duped_board[row_ind][column_ind] = new_piece
        new_piece.position = new_piece.position.dup
      end
    end
    self.class.new(duped_board)
  end

  #gets the direction a move is going, in the smallest possible step
  def get_direction start_pos, end_pos
    difference = [end_pos[0] - start_pos[0] , end_pos[1] - start_pos[1]]
    difference.map do |value|
      if value == 0
        value
      else
        puts value
        value/(value.abs)
      end
    end
  end

  #sees if the given color's king is in check
  def check? color
  end

  #sees if game is over
  def checkmate?
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