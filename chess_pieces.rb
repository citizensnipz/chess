require './chess_board'

class Piece
	attr_accessor :pos, :icon
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
end

class King < Piece
	def initialize(player)
		@icon = (player == "player1") ? "\u2654" : "\u265A"
	end

	def next_move_list(pieces)
		y,x = self.pos[0],self.pos[1]
		@move_list = [[y+1,x],[y,x+1],[y+1,x+1],[y-1,x],[y,x-1],[y-1,x-1],[y+1,x-1],[y-1,x+1]]
		#validate the moves are on the board
		@move_list.each_index do |ind|
			if (@move_list[ind][0] > 8)||(@move_list[ind][0] < 1)
				@move_list.delete_at(ind)
			elsif (@move_list[ind][1] > 8)||(@move_list[ind][1] < 1)
				@move_list.delete_at(ind)
			end
		end
		#finds if next squares are occupied
		pieces.each do |piece|
			if @move_list.include? piece.pos
				@move_list.delete(piece.pos)
			end
		end
		return @move_list
	end
end

class Queen < Piece
	def initialize(player)
		@icon = (player == "player1") ? "\u2655" : "\u265B"
	end
end

class Bishop < Piece
	def initialize(player)
		@icon = (player == "player1") ? "\u2657" : "\u265D"
	end
end

class Knight < Piece
	def initialize(player)
		@icon = (player == "player1") ? "\u2658" : "\u265E"
	end
end

class Rook < Piece
	def initialize(player)
		@icon = (player == "player1") ? "\u2656" : "\u265C"
	end
	
	def next_move_list(pieces, root)
		y,x = self.pos[0],self.pos[1]
		@move_list = []
		up,down,left,right = [y+1,x],[y-1,x],[y,x-1],[y,x+1]
		until up[0] == 9 do
			if root.find(up).nil?
				break
			end
			#if space is not occupied by player's pieces or is empty
			if root.find(up).piece.nil?
				@move_list << up
				up = [up[0]+1,up[1]]
			elsif root.player_squares(pieces).include? root.find(up)
				break
			else
				@move_list << up
				break
			end
		end
		until down[0] == 0 do
			if root.find(down).nil?
				break
			end
			if root.find(down).piece.nil?
				@move_list << down
				down = [down[0]-1,down[1]]
			elsif root.player_squares(pieces).include? root.find(down)
				break
			else
				@move_list << down
				break
			end
		end
		until left[1] == 0 do
			if root.find(left).nil?
				break
			end
			if root.find(left).piece.nil? 
				@move_list << left
				left = [left[0],left[1]-1]
			elsif root.player_squares(pieces).include? root.find(left)
				break
			else
				@move_list << left
				break
			end
		end
		until right[1] == 9 do
			if root.find(right).nil?
				break
			end
			if root.find(right).piece.nil?
				@move_list << right
				right = [right[0],right[1]+1]
			elsif root.player_squares(pieces).include? root.find(right)
				break
			else
				@move_list << right
				break
			end
		end
		return @move_list
	end
end

class Pawn < Piece
	def initialize(player)
		@icon = (player == "player1") ? "\u2659" : "\u265F"
		@player = player
	end

	def next_move_list(root)
		y,x = self.pos[0],self.pos[1]
		#shows moves up or down depending on player's side
		if @player == "player2"
			@move_list = (y+1)<9 ? [y+1,x] : []
		else
			@move_list = (y-1)>0 ? [y-1,x] : []
		end
		#finds if next squares are occupied
		next_move = root.find(@move_list)
		if next_move.piece.nil?
			return @move_list
		else
			@move_list = []
		end
	end
	
	def attack_squares
		y,x = self.pos[0],self.pos[1]
		@attack_squares = []
		if x == 8
			@attack_squares << [y+1,x-1]
		elsif x == 1
			@attack_squares << [y+1,x+1]
		else
			@attack_squares << [y+1,x+1]
			@attack_squares << [y+1,x-1]
		end
	end
end
