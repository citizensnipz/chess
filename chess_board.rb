require './chess_pieces'

class Board
	def initialize
		arr1,arr2 = [1,2,3,4,5,6,7,8],[1,2,3,4,5,6,7,8]
		@grid = arr1.product(arr2)
	end
	def ready_board(player, pieces)
		if player == "player1"
			i = 15
			@grid.each_index do |ind|
				if ind < 16
					@grid[ind] = pieces[i].icon
					i -= 1
				end
			end
		else
			i = 0
			@grid.each_index do |ind|
				if ind > 47
					@grid[ind] = pieces[i].icon
					i += 1
				end
			end
		end
	end
	def show_board
		i = 0
		@grid.each_index do |pos|
			i = i>7 ? 0 : i
			if !@grid[pos].is_a? Array
				print "| #{@grid[pos]} |"
			else 
				print "|    |"
			end
			i += 1
			if i == 8
				puts "\n\n"
			end
		end
	end

	def update(former, current)
		i = @grid.index(former)
		@grid[i] = current
	end

end