class Board
  attr_accessor :board

  def initialize board_status = nil
    if board_status.nil?
      @board = Array.new(8) { [nil] * 8 }
    else
      @board = board_status
    end
  end

  #sets up pieces in new starting position
  def setup_pieces
    setup_color(:white)
    setup_color(:black)
  end

  def setup_color color
    pieces = []

    pieces << Rook.new(color) << Knight.new(color) << Bishop.new(color)
    pieces << Queen.new(color) << King.new(color) << Bishop.new(color)
    pieces << Knight.new(color) << Rook.new(color)
    pawns = []

    8.times do |x|
      pawns << Pawn.new(color)
    end

    if color == :white
      fill_row(0, pieces)
      fill_row(1, pawns)
    elsif color == :black
      fill_row(7, pieces)
      fill_row(6, pawns)
    end
  end


  def fill_row row_ind, pieces
    @board[row_ind].each_with_index do |square, ind|
      @board[row_ind][ind] = pieces.shift
      @board[row_ind][ind].position = [row_ind, ind]
    end
  end

  def make_move start_pos, end_pos
    piece = @board[start_pos[0]][start_pos[1]]
    @board[end_pos[0]][end_pos[1]] = piece
    piece.position = end_pos
    @board[start_pos[0]][start_pos[1]] = nil
  end

  def is_valid_move? start_pos, end_pos, color
    return false unless movement_helper?(start_pos, end_pos, color)

    return false if puts_self_in_check?(start_pos, end_pos, color)

    true
  end

  def movement_helper?(start_pos, end_pos, color)
    piece = @board[start_pos[0]][start_pos[1]]

    return false if piece.color != color

    if !piece.possible_moves.include?(end_pos)
      return false
    end

    if same_color_collision?(start_pos, end_pos)
      return false
    end

    if piece.is_a?(SlidingPiece)
      return false if sliding_piece_collision?(start_pos, end_pos)
    end

    true
  end

  #looks at the path of sliding pieces for a collision
  def sliding_piece_collision? start_pos, end_pos
    direction = get_direction(start_pos, end_pos)
    pos = start_pos.dup

    #incrementally moves pos towards the end_pos
    until pos == end_pos
      pos[0] += direction[0]
      pos[1] += direction[1]

      return false if pos == end_pos #need to code this better

      if !@board[pos[0]][pos[1]].nil? #a piece is in the way!
        return true
      end
    end
    false
  end

  def puts_self_in_check? start_pos, end_pos, color
    test_board = self.deep_dup
    test_board.make_move(start_pos, end_pos)
    test_board.check?(color)
  end


  #sees if the given color's king is in check
  def check? color
    if color == :white
      pieces = select_all_pieces_of(:black)
      king_position = find_king_position(color)
    else
      pieces = select_all_pieces_of(:white)
      king_position = find_king_position(color)
    end

    pieces.each do |piece|
      piece.possible_moves.each do |move|
        if movement_helper?(piece.position, move, piece.color) and move == king_position
          return true
        end
      end
    end
    false
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
    pieces = []
    @board.each do |row|
      row.each do |piece|
        pieces << piece if !piece.nil? and piece.color == color
      end
    end
    pieces
  end


  #returns the position of the selected king
  def find_king_position color
    @board.each_with_index do |row, row_ind|
      row.each_with_index do |piece, column_ind|
        return [row_ind, column_ind]  if piece.is_a?(King) and piece.color == color
      end
    end
    raise "Never found King, something's wrong"
  end

  def same_color_collision? (start_pos, end_pos)
    if get_board_piece(start_pos).is_a?(Piece) and get_board_piece(end_pos).is_a?(Piece)
      return true if get_board_piece(start_pos).color == get_board_piece(end_pos).color
    end
    false

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
    difference = [end_pos[0] - start_pos[0] , end_pos[1] - start_pos[1]]
    difference.map do |value|
      if value == 0
        value
      else
        value/(value.abs)
      end
    end
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
          color_set = piece_set[piece.color]
          row_output << color_set[piece.class.to_s.downcase.to_sym]
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

    { :white => white_unicode, :black => black_unicode }
  end
end