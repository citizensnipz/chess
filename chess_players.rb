require './chess_pieces'

class Player
	def initialize(input)
		@name = input
		@pieces_list = []
	end
	def pieces_list
		@pieces_list
	end
	#def choose
	#	puts "Choose a square occupied by your selected piece"
	#	piece = gets.chomp
	#	puts "Select the destination for your piece"
	#	destination = gets.chomp
	#	@grid.index[piece] = piece_position
	#	@grid.index[destination] = piece_destination
	#end

	def get_name
		@name
	end

	def ready_pieces
		king = King.new(@name)
		queen = Queen.new(@name)
		bishop1,bishop2 = Bishop.new(@name),Bishop.new(@name)
		knight1,knight2 = Knight.new(@name),Knight.new(@name)
		rook1,rook2 = Rook.new(@name),Rook.new(@name)
		pawn1,pawn2,pawn3,pawn4,pawn5,pawn6,pawn7,pawn8 = Pawn.new(@name),Pawn.new(@name),Pawn.new(@name),Pawn.new(@name),Pawn.new(@name),Pawn.new(@name),Pawn.new(@name),Pawn.new(@name)
		if @name == "player1"
			@pieces_list = [pawn1,pawn2,pawn3,pawn4,pawn5,pawn6,pawn7,pawn8,rook1,knight1,bishop1,king,queen,bishop2,knight2,rook2]
		else
			@pieces_list = [pawn1,pawn2,pawn3,pawn4,pawn5,pawn6,pawn7,pawn8,rook1,knight1,bishop1,queen,king,bishop2,knight2,rook2]
		end
	end

end 