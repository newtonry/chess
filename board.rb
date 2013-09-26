require "colorize"

class Board
  VISUAL_PIECE_SET = {
    :king => "\u265A",
    :queen => "\u265B",
    :rook => "\u265C",
    :bishop => "\u265D",
    :knight => "\u265E",
    :pawn => "\u265F"
  }

  attr_accessor :board

  def initialize board = nil
    @board = board || Array.new(8) { Array.new(8) }
    # if board_status.nil?
    #   @board = Array.new(8) { Array.new(8) }
    # else
    #   @board = board_status
    # end
  end

  #sets up pieces in new starting position
  def setup_pieces
    setup_color(:white)
    setup_color(:black)
  end

  def setup_color color
    pieces = [
      Rook,
      Knight,
      Bishop,
      Queen,
      King,
      Bishop,
      Knight,
      Rook
    ]

    pawns = []
    8.times { pawns << Pawn }

    if color == :white
      fill_row(0, pieces, color)
      fill_row(1, pawns, color)
    else
      fill_row(7, pieces, color)
      fill_row(6, pawns, color)
    end
  end


  def fill_row row_ind, pieces, color
    @board[row_ind].each_with_index do |square, ind|
      piece_class = pieces.shift
      piece = piece_class == Pawn ? piece_class.new(color, [row_ind, ind], self) : piece_class.new(color, [row_ind, ind])
      @board[row_ind][ind] = piece
    end
  end

  # def []
  # def []=
  # def piece_at
  # def set_piece_at

  def make_move start_pos, end_pos
    piece = get_board_piece(start_pos)
    @board[end_pos[0]][end_pos[1]] = piece
    piece.position = end_pos
    @board[start_pos[0]][start_pos[1]] = nil
  end

  def is_valid_move? start_pos, end_pos, color
    return false unless movement_helper?(start_pos, end_pos, color)
    return false if puts_self_in_check?(start_pos, end_pos, color)

    true
  end

  # def valid_without_check?
  def movement_helper?(start_pos, end_pos, color)
    piece = @board[start_pos[0]][start_pos[1]]

    return false if piece.nil?
    return false if piece.color != color
    return false if !piece.possible_moves.include?(end_pos)
    return false if same_color_collision?(start_pos, end_pos)
    return false if piece.is_a?(SlidingPiece) && sliding_piece_collision?(start_pos, end_pos)
    true
  end

  #looks at the path of sliding pieces for a collision
  def sliding_piece_collision? start_pos, end_pos
    direction = get_direction(start_pos, end_pos)
    pos = start_pos.dup

    #incrementally moves pos towards the end_pos
    until pos == [end_pos[0] - direction[0], end_pos[1] - direction[1]]
      pos[0] += direction[0]
      pos[1] += direction[1]

      return true if get_board_piece(pos) #a piece is in the way!
    end
    false
  end

  def puts_self_in_check? start_pos, end_pos, color
    test_board = self.deep_dup
    test_board.make_move(start_pos, end_pos)
    test_board.check?(color)
  end

  def other_color color
    color == :white ? :black : :white
  end

  #sees if the given color's king is in check
  def check? color
    pieces = select_all_pieces_of(other_color(color))
    king_position = find_king_position(color)

    pieces.any? do |piece|
      piece.possible_moves.any? do |move|
        movement_helper?(piece.position, move, piece.color) && move == king_position
      end
    end
  end

  #sees if game is over
  def checkmate? color
    return false unless check?(color)
    pieces = select_all_pieces_of(color)
    pieces.each do |piece|
      piece.possible_moves.each do |move|
        if movement_helper?(piece.position, move, piece.color)
          test_board = self.deep_dup
          test_board.make_move(piece.position, move)
          return false unless test_board.check?(color)
        end
      end
    end
    true
  end

  def select_all_pieces_of color
    [].tap do |pieces|
      @board.each do |row|
        row.each do |piece|
          pieces << piece if piece && piece.color == color
        end
      end
    end
  end

  #returns the position of the selected king
  def find_king_position color
    @board.each_with_index do |row, row_ind|
      row.each_with_index do |piece, column_ind|
        return [row_ind, column_ind] if piece.is_a?(King) && piece.color == color
      end
    end
    raise "Never found King, something's wrong"
  end

  def same_color_collision? start_pos, end_pos
    start_piece = get_board_piece(start_pos)
    end_piece = get_board_piece(end_pos)
    start_piece && end_piece && start_piece.color == end_piece.color
  end

  def get_board_piece pos
    @board[pos[0]][pos[1]]
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
    difference = [end_pos[0] - start_pos[0], end_pos[1] - start_pos[1]]
    difference.map { |value| value <=> 0 }
  end

  def get_pawn_in_back_row
    (@board[7] + @board[0]).find do |piece|
      piece.is_a?(Pawn)
    end
  end

  def castle_possible color
    return false if check?(color)
    row = color == :white ? 0 : 7
    king = get_board_piece([row, 4])
    return false if !king.is_a?(King) || king.has_moved

    rooks = [get_board_piece([row, 0]), get_board_piece([row, 7])]
    rooks.select! do |rook|
      rook.is_a?(Rook) && !rook.has_moved && test_castle_path?(king, rook)
    end
    return false if rooks.empty?

    true
  end

  def test_castle_path? king, rook
    test_board = deep_dup
    king = test_board.get_board_piece(king.position)
    rook = test_board.get_board_piece(rook.position)
    row = king.position[0]
    king_col, rook_col = king.position[1], rook.position[1]
    col_range = rook_col > king_col ? (king_col + 1..rook_col - 1) : (rook_col + 1..king_col - 1)
    col_range.each do |col|
      pos = [row, col]
      return false unless test_board.get_board_piece(pos).nil?
      test_board.make_move(king.position, pos)
      return false if test_board.check?(king.color)
    end
    true
  end


  def to_s
    #NOTICE THAT THE BOARD IS REVERSED HERE, LOOKING FROM WHITE'S POV
    board_output = ""
    backgrounds = [:cyan, :light_blue]

    @board.reverse.each_with_index do |row, ind|
      row_output = ""
      row.each do |piece|
        if piece.nil?
          row_output << "  ".colorize(:background => backgrounds[0])
        else
          piece_output = VISUAL_PIECE_SET[piece.class.to_s.downcase.to_sym] + " "
          piece_output = piece_output.colorize(:color => piece.color, :background => backgrounds[0])
          row_output << piece_output
        end
        backgrounds.reverse!
      end
      board_output << "#{8 - ind} " + row_output + " \n"
      backgrounds.reverse!
    end

    board_output << "  " + ("A".."H").to_a.join(" ")
    board_output
  end
end