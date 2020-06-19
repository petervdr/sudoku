puts "GENERATING SUDOKU TABLE"
puts "-------------"
std_seq = [1,2,3,4,5,6,7,8,9]
board = Array.new
i=1

while i <= 9
	
	seq_to_div = std_seq
	board[i] = Array.new

	print "|"

	if i == 1
		seq_to_div.shuffle!
		seq_to_div.collect!.with_index do |x,y| 
			(y==3 || y==6) ? print("|#{x}") : print(x) 
			board[i][y]=x
		end	
	end

	if i == 2 
	 	[0..8].seq
	end

	puts "|"
	i += 1
end

puts "-------------"
