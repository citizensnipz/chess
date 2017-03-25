module Mod

class Piece
	attr_accessor :pos, :icon
	def initialize
		@pos = []
		@icon = ""
	end

	def icon
		@icon
	end
end

class King < Piece
	def initialize(player)
		if player == "player1"
			@icon = "\u2654"
		else
			@icon = "\u265A"
		end
	end

	def move

	end
end

class Queen < Piece
	def initialize(player)
		if player == "player1"
			@icon = "\u2655"
		else
			@icon = "\u265B"
		end
	end
end

class Bishop < Piece
	def initialize(player)
		if player == "player1"
			@icon = "\u2657"
		else
			@icon = "\u265D"
		end
	end
end

class Knight < Piece
	def initialize(player)
		if player == "player1"
			@icon = "\u2658"
		else
			@icon = "\u265E"
		end
	end
end

class Rook < Piece
	def initialize(player)
		if player == "player1"
			@icon = "\u2656"
		else
			@icon = "\u265C"
		end
	end
end

class Pawn < Piece
	def initialize(player)
		if player == "player1"
			@icon = "\u2659"
		else
			@icon = "\u265F"
		end
	end
end