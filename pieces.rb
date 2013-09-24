class Piece

  #creates the piece in a given position
  def initialize position

  end

  #moves the piece
  def move
  end

  #list of valid moves
  def valid_moves
  end

  def is_valid_move?
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
end


class King
  def initialize
    @unicode = "\u2654"
  end
end

class Knight
  def initialize
    @unicode = "\u2658"
  end
end


class Pawn < Piece
  "\u2659"

end



