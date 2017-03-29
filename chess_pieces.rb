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

	def next_move_list
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
end

class Pawn < Piece
	def initialize(player)
		@icon = (player == "player1") ? "\u2659" : "\u265F"
	end

	def next_move_list
		y,x = self.pos[0],self.pos[1]
		@move_list = (y+1)<8 ? [y+1,x] : []
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