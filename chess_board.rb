require './chess_pieces'
require './chess_players'

class Board
	def initialize
		@root = Square.new
		@root.create_grid
	end
	
	def ready_board(player)
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

	def update(current_pos, new_pos)
		@root.grid.each do |square|
			if square.position == current_pos
				@piece = square.piece
				square.piece = nil
				@piece.pos = new_pos
			elsif square.position == new_pos
				square.piece = @piece
			end
		end
	end

end

class Square
	attr_accessor :position, :piece, :grid
	def initialize
		@position = []
		@piece = nil
	end
	
	def create_grid
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
		
end