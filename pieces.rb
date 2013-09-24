class Piece
  attr_accessor :position

  #creates the piece in a given position
  def initialize
    @unicode = ''
    @position = position
  end

  def set_position position
    #in [row, column] formate
    @position = position
  end

  def unicode
    @unicode
  end

  #moves the piece
  def move
  end

  #list of valid moves
  def valid_moves
  end

  def move_on_board? move
    return false if (!(0..7).include?(move[0]) or !(0..7).include?(move[1]))
    true
  end
end


#can move until the end of the board in move_dirs
class SlidingPiece < Piece
  def initialize
    @diagonal_dirs = [[1, 1], [1, -1], [-1, -1], [-1, 1]]
    @straight_dirs = [[1, 0], [0, -1], [-1, 0], [0, 1]]
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
  def initialize
    #find a way to get rid of this
    @straight_dirs = [[1, 0], [0, -1], [-1, 0], [0, 1]]
  end

  def move_dirs
    @straight_dirs
  end
end

class Bishop < SlidingPiece
  def initialize
    #find a way to get rid of this
    @diagonal_dirs = [[1, 1], [1, -1], [-1, -1], [-1, 1]]
  end

  def move_dirs
    @diagonal_dirs
  end

end

class Queen < SlidingPiece
  def initialize
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

  def possible_moves
    move_dirs.map do |dir|
#      p [position[0] + dir[0], position[1] + dir[1]]

      [position[0] + dir[0], position[1] + dir[1]]
    end.select {|move| move_on_board?(move) and move != @position}
  end
end


class King < SteppingPiece
  def initialize
  end

  def move_dirs
    [1,0,0,-1,1,-1].combination(2).to_a.uniq
  end

end

class Knight < SteppingPiece
  def initialize
  end

  def move_dirs
    steps = [1,2,-1,-2].permutation(2).to_a.reject do |combo|
      combo[0] + combo[1] == 0
    end
  end
end


class Pawn < Piece
end



