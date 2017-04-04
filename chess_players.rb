require './chess_pieces'
require './chess_board'

class Player
	attr_reader :name
	attr_accessor :root
	def initialize(input, root)
		@name = input
		@pieces_list = []
		@root = root
	end
	def pieces_list
		@pieces_list
	end
	def choose
		begin
			puts "Choose a square occupied by your selected piece (i.e. 7,1 or 5,6)"
			position = gets.chomp
			pos_arr = Array([position[0].to_i,position[2].to_i])
			piece = @root.find(pos_arr).piece
			if piece.nil?
				raise InputError.new("That is an empty square")
			elsif !self.pieces_list.include? piece
				raise InputError.new("That piece belongs to your enemy")
			end
			puts "Select the destination for your piece"
			destination = gets.chomp
			dest_arr = Array([destination[0].to_i,destination[2].to_i])
			if !piece.next_move_list(@root).include? dest_arr
				raise InputError.new("That piece cannot move there")
			end
		rescue
			puts "Please try a different location"
			retry
		end
		piece.move(dest_arr, @root)
	end

	def ready_pieces
	#initializes all the piece objects at the beginning of the game
	#makes a list '@pieces_list' containing all of the pieces for a given player
		king = King.new(self)
		queen = Queen.new(self)
		bishop1,bishop2 = Bishop.new(self),Bishop.new(self)
		knight1,knight2 = Knight.new(self),Knight.new(self)
		rook1,rook2 = Rook.new(self),Rook.new(self)
		pawn1,pawn2,pawn3,pawn4,pawn5,pawn6,pawn7,pawn8 = Pawn.new(self),Pawn.new(self),Pawn.new(self),Pawn.new(self),Pawn.new(self),Pawn.new(self),Pawn.new(self),Pawn.new(self)
		if @name == "player1"
			@pieces_list = [rook2,knight2,bishop2,queen,king,bishop1,knight1,rook1,pawn8,pawn7,pawn6,pawn5,pawn4,pawn3,pawn2,pawn1]
		else
			@pieces_list = [pawn1,pawn2,pawn3,pawn4,pawn5,pawn6,pawn7,pawn8,rook1,knight1,bishop1,queen,king,bishop2,knight2,rook2]
		end
	end
	
	def find_piece(position)
		@pieces_list.each do |piece|
			if piece.pos == position
				return piece
			else
				return nil
			end
		end
	end
end

class InputError < StandardError
	def initialize(message)
		puts message
	end
end