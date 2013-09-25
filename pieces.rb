class Piece
  attr_accessor :position, :color

  #creates the piece in a given position
  def initialize color
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
  def initialize color
    @diagonal_dirs = [[1, 1], [1, -1], [-1, -1], [-1, 1]]
    @straight_dirs = [[1, 0], [0, -1], [-1, 0], [0, 1]]
    super(color)
  end

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
  def initialize color
    super(color)
    #find a way to get rid of this
    @straight_dirs = [[1, 0], [0, -1], [-1, 0], [0, 1]]
  end

  def move_dirs
    @straight_dirs
  end
end

class Bishop < SlidingPiece
  def initialize color
    super(color)

    #find a way to get rid of this
    @diagonal_dirs = [[1, 1], [1, -1], [-1, -1], [-1, 1]]
  end

  def move_dirs
    @diagonal_dirs
  end

end

class Queen < SlidingPiece
  def initialize color
    super(color)
    #find a way to get rid of this
    @diagonal_dirs = [[1, 1], [1, -1], [-1, -1], [-1, 1]]
    @straight_dirs = [[1, 0], [0, -1], [-1, 0], [0, 1]]
  end

  def move_dirs
    @diagonal_dirs + @straight_dirs
  end
end


#stepping pieces can move 1
class SteppingPiece < Piece
  def initialize color
    super(color)
  end

  def possible_moves
    move_dirs.map do |dir|
      [position[0] + dir[0], position[1] + dir[1]]
    end.select { |move| move_on_board?(move) and move != @position }
  end
end

class King < SteppingPiece
  def initialize color
    super(color)
  end

  def move_dirs
    [1,0,0,-1,1,-1].combination(2).to_a.uniq
  end
end

class Knight < SteppingPiece
  def initialize color
    super(color)
  end

  def move_dirs
    steps = [1,2,-1,-2].permutation(2).to_a.reject do |combo|
      combo[0] + combo[1] == 0
    end
  end
end


class Pawn < Piece
  def initialize color
    super(color)
  end

  def possible_moves

    #still lacking possible diagonal moves
    direction = @color == :white ? 1 : -1

    move = [@position[0] + direction, @position[1]]
    return [] if !move_on_board?(move)

    [move]
  end
end



