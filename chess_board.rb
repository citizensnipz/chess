require './chess_pieces'
require './chess_players'

class Board
	attr_accessor :root
	def initialize
		@root = Square.new
		@root.create_grid
	end
	def ready_board(player)
	#runs the methods to setup the board for both players at once
		if player.name == "player1"
			@root.setup(player.name, player.pieces_list)
		else
			@root.setup(player.name, player.pieces_list)
		end
	end
	
	def show_board
		i = 0
		n = 8
		@root.grid.each_index do |pos|
			i = i>7 ? 0 : i
			if (pos == 0)||(pos%8 == 0)
				print " #{n} "
				if !@root.grid[pos].piece.nil?
					print "| #{@root.grid[pos].piece.icon} |"
				else
					print "|    |"
				end
				n -= 1
			elsif !@root.grid[pos].piece.nil?
				print "| #{@root.grid[pos].piece.icon} |"
			else
				print "|    |"
			end
			i += 1
			if i == 8
				puts "\n\n"
			end
		end
		print "     a     b     c     d     e     f     g     h  "
		puts "\n\n"
	end
end

class Square
	attr_accessor :position, :piece, :grid
	def initialize
		@position = []
		@piece = nil
	end
	def create_grid
	#generates a grid of Square objects with coordinates
		arr1,arr2 = [8,7,6,5,4,3,2,1],[1,2,3,4,5,6,7,8]
		@coords = arr1.product(arr2)
		@grid = []
		@coords.each_index do |ind|
			square = Square.new
			square.position = @coords[ind]
			@grid << square
		end
	end
	
	def setup(player, pieces)
	#puts the pieces on the board at the start of the game
		if player == "player1"
			@grid.each_index do |ind|
				if ind < 16
					pieces[ind].pos = @grid[ind].position
					@grid[ind].piece = pieces[ind]
				end
			end
		else
			i = 0
			@grid.each_index do |ind|
				if ind > 47
					pieces[i].pos = @grid[ind].position
					@grid[ind].piece = pieces[i]
					i += 1
				end
			end
		end
	end
	
	def find(position)
		#returns a square with a given coordinate
		@grid.each do |square|
			if square.position == position
				return square
			end
		end
		return nil
	end
	
	def player_squares(pieces)
		#returns an array of Squares occupied by the given player's pieces
		square_list = []
		@grid.each do |square|
			if pieces.include? square.piece
				square_list << square
			end
		end
		return square_list
	end
	
	def empty_squares
		#returns an array of coordinates that are unoccupied by any player
		empty_list = []
		@grid.each do |square|
			if square.piece.nil?
				empty_list << square.position
			end
		end
		return empty_list
	end
		
end