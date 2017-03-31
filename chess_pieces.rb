require './chess_board'

class Piece
	attr_accessor :pos, :icon, :move_list
	def initialize
		@pos = []
		@icon = ""
	end

	def move(new_pos, root)
		root.grid.each do |square|
			if square.position == self.pos
				square.piece = nil
			elsif square.position == new_pos
				square.piece = self
			end
		end
		self.pos = new_pos
	end
	
	def move_list_cleanup(list, pieces, root, check = false)
		list.delete_if { |move|
			((move[0]>8)||(move[1]<1))||((move[1]>8)||move[1]<1)
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

	def next_move_list(root)
		y,x = self.pos[0],self.pos[1]
		#shows moves up or down depending on player's side
		if @player.name == "player2"
			move_list = (y+1)<9 ? [y+1,x] : []
		else
			move_list = (y-1)>0 ? [y-1,x] : []
		end
		#finds if next square is occupied
		next_move = root.find(move_list)
		if next_move.piece.nil?
			return move_list
		else
			move_list = []
		end
	end
	
	def attack_squares
		y,x = self.pos[0],self.pos[1]
		attack_squares = []
		if x == 8
			attack_squares << [y+1,x-1]
		elsif x == 1
			attack_squares << [y+1,x+1]
		else
			attack_squares << [y+1,x+1]
			attack_squares << [y+1,x-1]
		end
	end
end