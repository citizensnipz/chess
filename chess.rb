require './chess_board'
require './chess_pieces'
require './chess_players'

class Chess

	def initialize
		@board = Board.new
		@player1,@player2 = Player.new("player1"),Player.new("player2")
		@player1.ready_pieces
		@player2.ready_pieces
		@board.ready_board(@player1)
		@board.ready_board(@player2)

	end

	def has_check?

	end

	def has_checkmate?

	end

	def play
		@board.show_board
		@board.update([8,1],[6,1])
		@board.show_board
	end
end

c = Chess.new
c.play