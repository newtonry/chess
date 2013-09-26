class Piece
  DIAGONAL_DIRS = [[1, 1], [1, -1], [-1, -1], [-1, 1]]
  STRAIGHT_DIRS = [[1, 0], [0, -1], [-1, 0], [0, 1]]

  attr_accessor :position, :color

  #creates the piece in a given position
  def initialize color, position
    @color = color
    @position = position
  end

  def move_on_board? move
    return (0..7).include?(move[0]) && (0..7).include?(move[1])
  end
end

#can move until the end of the board in move_dirs
class SlidingPiece < Piece
  def possible_moves
    [].tap do |poss_moves|
      #needs to take move_dirs and vectorize the dirs
      move_dirs.each do |dir|
        magnitude = 1
        loop do
          move_vec = dir.map { |el| el * magnitude}
          move = [@position[0] + move_vec[0], @position[1] + move_vec[1]]

          break unless move_on_board?(move)

          poss_moves << move
          magnitude += 1
        end
      end
    end
  end
end

class Rook < SlidingPiece
  attr_accessor :has_moved

  def initialize color, position
    super(color, position)
    @has_moved = false
  end

  def position= position
    @has_moved = true
    @position = position
  end

  def move_dirs
    STRAIGHT_DIRS
  end
end

class Bishop < SlidingPiece
  def move_dirs
    DIAGONAL_DIRS
  end
end

class Queen < SlidingPiece
  def move_dirs
    DIAGONAL_DIRS + STRAIGHT_DIRS
  end
end

#stepping pieces can move 1
class SteppingPiece < Piece
  def possible_moves
    move_dirs.map do |dir|
      [position[0] + dir[0], position[1] + dir[1]]
    end.select { |move| move_on_board?(move) }
  end
end

class King < SteppingPiece
  attr_accessor :has_moved

  def initialize color, position
    super(color, position)
    @has_moved = false
  end

  def position= position
    @has_moved = true
    @position = position
  end

  def move_dirs
    STRAIGHT_DIRS + DIAGONAL_DIRS
  end
end

class Knight < SteppingPiece
  def move_dirs
    [1, 2, -1, -2].permutation(2).to_a.reject do |combo|
      combo[0] + combo[1] == 0
    end
  end
end

class Pawn < Piece
  def initialize color, position, board
    super(color, position)
    @board = board
  end

  def possible_moves
    direction = @color == :white ? 1 : -1

    moves = []
    basic_move = [@position[0] + direction, @position[1]]
    if move_on_board?(basic_move) && @board.get_board_piece(basic_move).nil?
      moves << basic_move
      first_move = [@position[0] + (direction * 2), @position[1]]
      if @board.get_board_piece(first_move).nil? &&
        ((@color == :white && position[0] == 1) || (@color == :black && position[0] == 6))
        moves << first_move
      end
    end

    attacks = [
      [@position[0] + direction, @position[1] + 1],
      [@position[0] + direction, @position[1] - 1]
    ]
    attacks.select! do |move|
      if move_on_board?(move)
        attacked_piece = @board.get_board_piece(move)
        attacked_piece != nil and attacked_piece.color != @color
      else
        false
       end
    end

    moves + attacks
  end
end