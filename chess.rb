require './chess_board'
require './chess_pieces'
require './chess_players'

class Chess

	def initialize
		board = Board.new
		player1 = Player.new("player1")
		player2 = Player.new("player2")
		player1.ready_pieces
		player2.ready_pieces
		board.ready_board("player1", player1.pieces_list)
		board.ready_board("player2", player2.pieces_list)
		board.show_board

	end

	def has_check?

	end

	def has_checkmate?

	end

end

c = Chess.new