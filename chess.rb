require './chess_board'
require './chess_pieces'
require './chess_players'

class Chess
	attr_reader :board
	def initialize
		@board = Board.new
		@player1,@player2 = Player.new("player1", @board.root),Player.new("player2", @board.root)
		@player1.ready_pieces
		@player2.ready_pieces
		@board.ready_board(@player1)
		@board.ready_board(@player2)

	end

	def has_check?(player, possible_move = [])
		#check is used when king's current position is under threat
		#will substitute king's position for given position
		#position substitution only means that position is under threat
		queue = []
		value = false
		enemy = player.name == "player1" ? @player2 : @player1
		player_king = player.name == "player1" ? player.pieces_list[4] : player.pieces_list[12]
		enemy_queue = self.vulnerable_squares(enemy)
		checked_pos = possible_move.empty? ? player_king.pos : possible_move
		enemy_queue.each do |attacked_position|
			if checked_pos == attacked_position
				value = true
				return value
				break
			end
		end
		return value
	end
	
	def has_checkmate?(player)
		#checkmate is used when king's next moves are all under threat
		queue = []
		value = false
		enemy = player.name == "player1" ? @player2 : @player1
		player_king = player.name == "player1" ? player.pieces_list[4] : player.pieces_list[12]
		player_king_move_list = player_king.next_move_list(@board.root)
		player_king_move_list.each do |king_move|
			if self.has_check?(player, king_move)
				value = true
				return value
			else
				value = false
			end
		end
		puts "Checkmate was #{value}"
		return value
	end
	
	
	def virtual_move_check(piece, move, player)
		#used in blocking_check
		#returns TRUE if that move places king in check
		#returns FALSE if that move does not place the king in check
		#resets the board on every use
		old_pos = piece.pos
		piece.move(move, @board.root, true)
		if self.has_check?(player)
			piece.unmove(old_pos, @board.root)
			return true
		else
			piece.unmove(old_pos, @board.root)
			return false
		end
	end
	
	
	def vulnerable_squares(enemy)
		#used in has_check?
		#creates a queue of squares that the given player can move to
		queue = []
		enemy.pieces_list.each do |enemy_piece|
			if enemy_piece == []
				next
			else
				queue = queue + enemy_piece.next_move_list(@board.root, true)
			end
		end
		return queue
	end

	def blocking_check(player)
		#finds if any of player's own pieces can block an attack and release the King from Check
		#returns TRUE if the player CAN block check with another piece
		queue = []
		value = true
		puts "Running a blocking check"
		player_pieces = player.pieces_list
		player_pieces.each do |piece|
			if piece == []
				next
			else
				piece_move_list = piece.next_move_list(@board.root)
				piece_move_list.each do |move|
					if !self.virtual_move_check(piece, move, player)
						value = false
						return value
					else
						next
					end
				end
			end
			if !value
				return value
			end
		end
		return value
	end

	def buggy_check
		@board.show_board
		self.virtual_move_check(@player2.pieces_list[0], [3,1], @player2)
		@board.show_board
	end

	def play
		checkmate = false
		current_player = @player2
		until checkmate do
			begin
				@board.show_board
				#flips which player is playing
				current_player = current_player == @player2 ? @player1 : @player2
				enemy_player = current_player == @player2 ? @player2 : @player1
				#checks if check already exists
				if (self.has_check?(current_player))&&(!self.blocking_check(current_player))
					puts "#{current_player.name} is in check!\n\n"
					puts "#{current_player.name} must defend their King or Checkmate will be declared\n\n"
					choices = current_player.choose
					attempted_piece = choices[0]
					attempted_move = choices[1]
					#validates that the next move will not put king in check
					if self.virtual_move_check(attempted_piece, attempted_move, current_player)
						raise InputError.new("That move puts the King in Check")
					elsif (self.blocking_check(current_player))&&(self.has_check?(current_player))
						puts "Congratulations! #{enemy_player.name} has won by Checkmate!"
						checkmate = true
						return checkmate
					#looks for checkmate
					else #assuming the move is valid and removes player from check, run this code \/ \/ \/
						choices[0].move(choices[1], @board.root)
					end
				elsif (self.blocking_check(current_player))&&(self.has_check?(current_player))
					puts "Congratulations! #{enemy_player.name} has won by Checkmate!"
					checkmate = true
					return checkmate
				else
					#if not in check, move as normal
					puts "It is #{current_player.name}'s turn...\n\n"
					choices = current_player.choose
					attempted_piece = choices[0]
					attempted_move = choices[1]
					#resets board if move puts King in check
					if self.virtual_move_check(attempted_piece, attempted_move, current_player)
						raise InputError.new("That move puts the King in Check")
					elsif (self.blocking_check(current_player))&&(self.has_check?(current_player))
						puts "Congratulations! #{enemy_player.name} has won by Checkmate!"
						checkmate = true
						return checkmate
					else #assuming the move is valid and removes player from check, run this code \/ \/ \/
						choices[0].move(choices[1], @board.root)
					end
				end
			rescue InputError
				current_player = current_player == @player2 ? @player1 : @player2
				puts "Please try again..."
				retry
			end
		end
	end
end

c = Chess.new
c.play