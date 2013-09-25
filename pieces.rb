class Piece
  attr_accessor :position, :color

  #creates the piece in a given position
  def initialize color, position = nil
    @position = position
    @color = color
  end

  def move_on_board? move
    return false if (!(0..7).include?(move[0]) or !(0..7).include?(move[1]))
    true
  end
end


#can move until the end of the board in move_dirs
class SlidingPiece < Piece
  DIAGONAL_DIRS = [[1, 1], [1, -1], [-1, -1], [-1, 1]]
  STRAIGHT_DIRS = [[1, 0], [0, -1], [-1, 0], [0, 1]]

  def possible_moves
    poss_moves = []
    #needs to take move_dirs and vectorize the dirs
    move_dirs.each do |dir|
      multiplier = 1
      loop do
        move_vec = dir.map { |el| el * multiplier}
        move = [@position[0] + move_vec[0], @position[1] + move_vec[1]]

        if move_on_board?(move) == false
          break
        end

        poss_moves << move
        multiplier += 1
      end
    end
    poss_moves
  end
end

class Rook < SlidingPiece
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
    end.select { |move| move_on_board?(move) and move != @position }
  end
end

class King < SteppingPiece
  def move_dirs
    [1,0,0,-1,1,-1].combination(2).to_a.uniq
  end
end

class Knight < SteppingPiece
  def move_dirs
    steps = [1,2,-1,-2].permutation(2).to_a.reject do |combo|
      combo[0] + combo[1] == 0
    end
  end
end


class Pawn < Piece
  def initialize color, board
    super(color)
    @board = board
  end

  def possible_moves
    direction = @color == :white ? 1 : -1

    moves = []
    basic_move = [@position[0] + direction, @position[1]]
    moves << basic_move if move_on_board?(basic_move) and @board.get_board_piece(basic_move).nil?
    first_move = [@position[0] + (direction * 2), @position[1]]
    if (@color == :white && position[0] == 1) || (@color == :black && position[0] == 6)
      moves << first_move
    end

    attacks = []
    attacks << [@position[0] + direction, @position[1] + 1]
    attacks << [@position[0] + direction, @position[1] - 1]


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



