require "./board.rb"
require "./pieces.rb"

class Chess
  def initialize
    @board = Board.new
  end

  def play
    @board.setup_pieces
    turn = [:white, :black]

    loop do
      @board.print_board
      puts

      puts "#{turn.first.to_s.capitalize}'s turn!"



      move = prompt_user_for_move
      next if move == nil
      if @board.is_valid_move?(move[0], move[1], turn.first)

        @board.make_move(move[0], move[1])

        upgrade_pawn = @board.get_pawn_in_back_row

        unless upgrade_pawn.nil?
          prompt_upgrade(upgrade_pawn)
        end




        turn.reverse!
        if @board.checkmate?(turn[0])
          puts "Checkmate! #{turn.first.to_s.capitalize} loses!"
          return
        end
      else
        puts "Not a valid move"
      end
    end
  end

  def prompt_upgrade piece
    puts "Your pawn is upgradeable. Please enter Q, K, B, or R"
    new_piece = gets.chomp.upcase

    new_piece = case new_piece
    when "Q" then Queen.new(piece.color, piece.position)
    when "K" then Knight.new(piece.color, piece.position)
    when "B" then Bishop.new(piece.color, piece.position)
    when "R" then Rook.new(piece.color, piece.position)
    end

    @board.board[piece.position[0]][piece.position[1]] = new_piece

  end

  def prompt_user_for_move
    print "Please enter the next move (e.g. a2 a3): "
    sanitize_input(gets)
  end

  def sanitize_input input
    input = input.strip.upcase
    return nil if input.empty?
    start_pos, end_pos = *input.split

    start_pos = start_pos.each_char.to_a
    start_pos = [start_pos[1].to_i - 1, start_pos[0].ord - "A".ord]
    end_pos = end_pos.each_char.to_a
    end_pos = [end_pos[1].to_i - 1, end_pos[0].ord - "A".ord]

    [start_pos, end_pos]
  end
end

game = Chess.new
game.play