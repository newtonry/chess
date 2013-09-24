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

  def valid_move? move
    #if out of bounds
    return false if (!(0..7).include?(move[0]) or !(0..7).include?(move[1]))
    true

    #write functionality for check



  end
end


#can move until the end of the board in move_dirs
class SlidingPiece < Piece
end

class Queen < SlidingPiece
  def initialize
    @unicode = "\u2655" # will have to switch based on color
  end
end

class Rook < SlidingPiece
  def initialize
    @unicode = "\u2656"
  end
end

class Bishop < SlidingPiece
  def initialize
    @unicode = "\u2657"
  end
end


#stepping pieces can move 1
class SteppingPiece < Piece

  def possible_moves
    move_dirs.map do |dir|
#      p [position[0] + dir[0], position[1] + dir[1]]

      [position[0] + dir[0], position[1] + dir[1]]
    end.select {|move| valid_move?(move) and move != @position}


  end


end


class King < SteppingPiece
  def initialize
    @unicode = "\u2654"
  end

  def move_dirs
    [1,0,0,-1,1,-1].combination(2).to_a.uniq
  end

end

class Knight < Piece
  def initialize
    @unicode = "\u2658"
  end
end


class Pawn < Piece
  "\u2659"

end



