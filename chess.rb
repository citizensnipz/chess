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
		queue = []
		check = true
		pieces.each do |piece|
			if !piece.is_a? Pawn
				queue = queue + piece.next_move_list(root, check)
			else
				queue = queue + piece.attack_squares
			end
		end
		if queue.include? [4,3]
			puts "it is in the queue"
		else
			puts "it is not in the queue"
		end
		value = ""
		king = player.name == "player1" ? player.pieces_list[4] : player.pieces_list[12]
		king_move_list = king.next_move_list(root)
		king_move_list.each do |king_move|
			puts "here's the king's moves: #{king_move}"
			if queue.include? king_move
				value = true
			else
				value = false
			end
		end
		return value
	end

	def play
		@board.show_board
		@player1.pieces_list[4].move([5,4], @board.root)
		@player1.pieces_list[15].move([4,4], @board.root)
		@player1.pieces_list[14].move([4,5], @board.root)
		@player1.pieces_list[13].move([5,5], @board.root)
		@player1.pieces_list[12].move([6,5], @board.root)
		@player1.pieces_list[11].move([6,4], @board.root)
		@player1.pieces_list[10].move([6,3], @board.root)
		@player1.pieces_list[9].move([5,3], @board.root)
		@player2.pieces_list[0].move([4,3], @board.root)
		@player2.pieces_list[13].move([3,2], @board.root)
		@board.show_board
		puts @player1.pieces_list[4].next_move_list(@board.root)
		puts self.has_check?(@player1, @player2.pieces_list, @board.root)
		puts self.has_checkmate?(@player1, @player2.pieces_list, @board.root)
	end
end

c = Chess.new
c.play