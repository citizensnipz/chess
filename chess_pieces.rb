require './chess_board'
require './chess_players'

class Piece
	attr_accessor :pos, :icon
	attr_reader :player
	def initialize(player)
		@pos = []
		@icon = ""
		@player = player
		@removed_piece = nil
		@removed_piece_index = 0
	end

	def move(new_pos, root, virtual = false)
		if virtual
			#describes the action if the move is only simulated
			#retains the removed piece in an instance variable, used to undo the move
			root.find(self.pos).piece = nil
			@removed_piece = root.find(new_pos).piece
			unless @removed_piece.nil?
				@removed_piece_index = @removed_piece.player.pieces_list.index(root.find(new_pos).piece)
				@removed_piece.player.erase_piece(root.find(new_pos).piece)
			end
			root.find(new_pos).piece = self
			self.pos = new_pos
		else
			root.find(self.pos).piece = nil
			if root.find(new_pos).piece.nil?
				root.find(new_pos).piece = self
				self.pos = new_pos
			else
				enemy_piece = root.find(new_pos).piece
				enemy_piece.player.erase_piece(enemy_piece)
				root.find(new_pos).piece = self
				self.pos = new_pos
			end
		end
	end
	
	def unmove(old_pos, root)
		@removed_piece.player.pieces_list[@removed_piece_index] = @removed_piece unless @removed_piece.nil?
		root.find(old_pos).piece = self
		root.find(self.pos).piece = @removed_piece
		self.pos = old_pos
	end
	
	
	def move_list_cleanup(list, pieces, root, check = false)
		list.delete_if { |move|
			((move[0]>8)||(move[0]<1))||((move[1]>8)||move[1]<1)
		}
		#removes moves containing player's own pieces, unless check is true
		unless check
			list.delete_if { |move|
				root.player_squares(pieces).include? root.find(move)	
			}
		end
		list
	end
	
	def extended_diag_tr(position, pieces, root)
		move_list = []
		position = [position[0]+1,position[1]+1]
		until root.find(position).nil? do
			#if square is unoccupied, add it to the list and increment
			if !root.find(position).piece.nil?
				move_list << position
				break
			else
				move_list << position
				position = [position[0]+1,position[1]+1]
			end
		end
		return move_list
	end
	
	def extended_diag_tl(position, pieces, root)
		move_list = []
		position = [position[0]+1,position[1]-1]
		until root.find(position).nil? do
			if !root.find(position).piece.nil?
				move_list << position
				break
			else
				move_list << position
				position = [position[0]+1,position[1]-1]
			end
		end
		return move_list
	end
	
	def extended_diag_br(position, pieces, root)
		move_list = []
		position = [position[0]-1,position[1]+1]
		until root.find(position).nil? do
			if !root.find(position).piece.nil?
				move_list << position
				break
			else
				move_list << position
				position = [position[0]-1,position[1]+1]
			end
		end
		return move_list
	end
	def extended_diag_bl(position, pieces, root)
		move_list = []
		position = [position[0]-1,position[1]-1]
		until root.find(position).nil? do
			if !root.find(position).piece.nil?
				move_list << position
				break
			else
				move_list << position
				position = [position[0]-1,position[1]-1]
			end
		end
		return move_list
	end
	
	def extended_vert_up(position, pieces, root)
		move_list = []
		position = [position[0]+1,position[1]]
		until root.find(position).nil? do
			if !root.find(position).piece.nil?
				move_list << position
				break
			else
				move_list << position
				position = [position[0]+1,position[1]]
			end
		end
		return move_list
	end
	
	def extended_vert_down(position, pieces, root)
		move_list = []
		position = [position[0]-1,position[1]]
		until root.find(position).nil? do
			if !root.find(position).piece.nil?
				move_list << position
				break
			else
				move_list << position
				position = [position[0]-1,position[1]]
			end
		end
		return move_list
	end
	
	def extended_horiz_left(position, pieces, root)
		move_list = []
		position = [position[0],position[1]-1]
		until root.find(position).nil? do
			if !root.find(position).piece.nil?
				move_list << position
				break
			else
				move_list << position
				position = [position[0],position[1]-1]
			end
		end
		return move_list
	end
	
	def extended_horiz_right(position, pieces, root)
		move_list = []
		position = [position[0],position[1]+1]
		until root.find(position).nil? do
			if !root.find(position).piece.nil?
				move_list << position
				break
			else
				move_list << position
				position = [position[0],position[1]+1]
			end
		end
		return move_list
	end
end






class King < Piece
	def initialize(player)
		@icon = (player.name == "player1") ? "\u2654" : "\u265A"
		@player = player
	end

	def next_move_list(root, check = false)
		y,x = self.pos[0],self.pos[1]
		move_list = [[y+1,x],[y,x+1],[y+1,x+1],[y-1,x],[y,x-1],[y-1,x-1],[y+1,x-1],[y-1,x+1]]
		#validate the moves are on the board
		if check
			self.move_list_cleanup(move_list, @player.pieces_list, root, check)
		else
			self.move_list_cleanup(move_list, @player.pieces_list, root, check)
		end
		return move_list
	end
end

class Queen < Piece
	def initialize(player)
		@icon = (player.name == "player1") ? "\u2655" : "\u265B"
		@player = player
	end
	
	def next_move_list(root, check = false)
		move_list = []
		tr = self.extended_diag_tr(self.pos, @player.pieces_list, root)
		tl = self.extended_diag_tl(self.pos, @player.pieces_list, root)
		br = self.extended_diag_br(self.pos, @player.pieces_list, root)
		bl = self.extended_diag_bl(self.pos, @player.pieces_list, root)
		up = self.extended_vert_up(self.pos, @player.pieces_list, root)
		down = self.extended_vert_down(self.pos, @player.pieces_list, root)
		left = self.extended_horiz_left(self.pos, @player.pieces_list, root)
		right = self.extended_horiz_right(self.pos, @player.pieces_list, root)
		move_list = tr + tl + br + bl + up + down + left + right
		if check
			self.move_list_cleanup(move_list, @player.pieces_list, root, check)
		else
			self.move_list_cleanup(move_list, @player.pieces_list, root, check)
		end
		return move_list
	end
end

class Bishop < Piece
	def initialize(player)
		@icon = (player.name == "player1") ? "\u2657" : "\u265D"
		@player = player
	end
	
	def next_move_list(root, check = false)
		tr = self.extended_diag_tr(self.pos, @player.pieces_list, root)
		tl = self.extended_diag_tl(self.pos, @player.pieces_list, root)
		br = self.extended_diag_br(self.pos, @player.pieces_list, root)
		bl = self.extended_diag_bl(self.pos, @player.pieces_list, root)
		move_list = tr + tl + br + bl
		if check
			self.move_list_cleanup(move_list, @player.pieces_list, root, check)
		else
			self.move_list_cleanup(move_list, @player.pieces_list, root, check)
		end
		return move_list
	end
	
end

class Knight < Piece
	def initialize(player)
		@icon = (player.name == "player1") ? "\u2658" : "\u265E"
		@player = player
	end
	
	def next_move_list(root, check = false)
		y,x = self.pos[0],self.pos[1]
		move_list = [[y+2,x+1],[y+1,x+2],[y+2,x-1],[y+1,x-2],[y-2,x+1],[y-1,x+2],[y-2,x-1],[y-1,x-2]]
		#removes moves off the board
		if check
			self.move_list_cleanup(move_list, @player.pieces_list, root, check)
		else
			self.move_list_cleanup(move_list, @player.pieces_list, root, check)
		end
		move_list
	end
end

class Rook < Piece
	def initialize(player)
		@icon = (player.name == "player1") ? "\u2656" : "\u265C"
		@player = player
	end
	
	def next_move_list(root, check = false)
		up = self.extended_vert_up(self.pos, @player.pieces_list, root)
		down = self.extended_vert_down(self.pos, @player.pieces_list, root)
		left = self.extended_horiz_left(self.pos, @player.pieces_list, root)
		right = self.extended_horiz_right(self.pos, @player.pieces_list, root)
		move_list = up + down + left + right
		if check
			self.move_list_cleanup(move_list, @player.pieces_list, root, check)
		else
			self.move_list_cleanup(move_list, @player.pieces_list, root, check)
		end
		return move_list
	end
end

class Pawn < Piece
	def initialize(player)
		@icon = (player.name == "player1") ? "\u2659" : "\u265F"
		@player = player
	end
	
	def next_move_list(root, check = false)
		y,x = self.pos[0], self.pos[1]
		move_list = []
		if @player.name == "player1"
			first_moves = y == 7 ? [[6,x],[5,x]] : [[y-1,x]]
			attack_move_left = (x-1)>0 ? [y-1,x-1] : []
			attack_move_right = (x+1)<9 ? [y-1,x+1] : []
		else
			first_moves = y == 2 ? [[3,x],[4,x]] : [[y+1,x]]
			attack_move_left = (x-1)>0 ? [y+1,x-1] : []
			attack_move_right = (x+1)<9 ? [y+1,x+1] : []
		end
		forward_square1 = root.find(first_moves[0])
		forward_square2 = first_moves.length > 1 ? root.find(first_moves[1]) : nil
		forward_piece1 = forward_square1.piece unless forward_square1.nil?
		forward_piece2 = forward_square2.piece unless forward_square2.nil?
		left_square = root.find(attack_move_left)
		right_square = root.find(attack_move_right)
		left_piece = left_square.piece unless left_square.nil?
		right_piece = right_square.piece unless right_square.nil?
		move_list = move_list + [attack_move_left] unless (left_piece.nil?)
		move_list = move_list + [attack_move_right] unless (right_piece.nil?)
		move_list = move_list + [first_moves[0]] unless !forward_piece1.nil?
		move_list = move_list + [first_moves[1]] unless !forward_piece2.nil?
		move_list.delete_if { |move|
			move.nil?
		}
		#cleanup the list by removing
		if !move_list.empty?
			clean_move_list = self.move_list_cleanup(move_list, @player.pieces_list, root, check)
			return clean_move_list
		else
			return move_list	
		end
	end
	
end