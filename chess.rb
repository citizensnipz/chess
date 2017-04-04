require './chess_board'
require './chess_pieces'
require './chess_players'

class Chess

	def initialize
		@board = Board.new
		@player1,@player2 = Player.new("player1", @board.root),Player.new("player2", @board.root)
		@player1.ready_pieces
		@player2.ready_pieces
		@board.ready_board(@player1)
		@board.ready_board(@player2)

	end

	def has_check?(player, pieces, root)
		#check is used when king's current position is under threat
		queue = []
		pieces.each do |piece|
			if !piece.is_a? Pawn
				queue = queue + piece.next_move_list(root)
			else
				queue = queue + piece.attack_squares
			end
		end
		king = player.name == "player1" ? player.pieces_list[4] : player.pieces_list[12]
		queue.each do |position|
			if king.pos == position
				return true
			end
		end
		return false
	end

	def has_checkmate?(player, pieces, root)
		#checkmate is used when king's next moves are all under threat
		queue = []
		check = true
		pieces.each do |piece|
			if !piece.is_a? Pawn
				queue = queue + piece.next_move_list(root, check)
			else
				queue = queue + piece.attack_squares
			end
		end
		value = false
		king = player.name == "player1" ? player.pieces_list[4] : player.pieces_list[12]
		king_move_list = king.next_move_list(root)
		if king_move_list.empty?
			value = true
		else
			king_move_list.each do |king_move|
				if queue.include? king_move
					value = true
				else
					value = false
				end
			end
		end
		return value
	end

	def play
		checkmate = false
		until checkmate do
			@board.show_board
			if self.has_check?(@player1, @player2.pieces_list, @board.root)
				puts "Player 1 is in check!"
				@player1.choose
				if self.has_checkmate?(@player1, @player2.pieces_list, @board.root)
					puts "Checkmate! Player 2 wins!"
					checkmate = true
					return checkmate
				end
			else
				puts "It is player 1's turn..."
				@player1.choose
			end
			@board.show_board
			if self.has_check?(@player2, @player1.pieces_list, @board.root)
				puts "Player 2 is in check!"
				@player2.choose
				if self.has_checkmate?(@player2, @player1.pieces_list, @board.root)
					puts "Checkmate! Player 1 wins!"
					checkmate = true
					return checkmate
				end
			else
				puts "It is player 2's turn..."
				@player2.choose
			end
		end
	end
end

c = Chess.new
c.play