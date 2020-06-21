def create_board
	$board = Array.new(82, 0)
	field_options = Array.new(82,nil)
	$std_seq = (1..9).to_a

	$boxes = Array.new
	$boxes[1] = [1,2,3,10,11,12,19,20,21]
	$boxes[2] = [4,5,6,13,14,15,22,23,24]
	$boxes[3] = [7,8,9,16,17,18,25,26,27]
	$boxes[4] = [28,29,30,37,38,39,46,47,48]
	$boxes[5] = [31,32,33,40,41,42,49,50,51]
	$boxes[6] = [34,35,36,43,44,45,52,53,54]
	$boxes[7] = [55,56,57,64,65,66,73,74,75]
	$boxes[8] = [58,59,60,67,68,69,76,77,78]
	$boxes[9] = [61,62,63,70,71,72,79,80,81]

	$rows = Array.new
	i=1
	while i < 10
		$rows[i] = ((i*9-8)..(i*9)).to_a
		i+=1
	end

	$cols = Array.new
	$cols[1] = [1,10,19,28,37,46,55,64,73]
	$cols[2] = [2,11,20,29,38,47,56,65,74]
	$cols[3] = [3,12,21,30,39,48,57,66,75]
	$cols[4] = [4,13,22,31,40,49,58,67,76]
	$cols[5] = [5,14,23,32,41,50,59,68,77]
	$cols[6] = [6,15,24,33,42,51,60,69,78]
	$cols[7] = [7,16,25,34,43,52,61,70,79]
	$cols[8] = [8,17,26,35,44,53,62,71,80]
	$cols[9] = [9,18,27,36,45,54,63,72,81]
end

def print_board
	puts "---------------------------------------------------------------------------"
	i = 1
	while i < 82
		if $board[i].kind_of?(Array) 
			len = 8 - $board[i].length
			n = 0
			while n < len
				print " " 
				n+=1 
			end
			$board[i].each {|e| print e}
		else 
			print "    #{$board[i]}   " 
		end
		print "|" if i%3 ==0
		print "\n                        |                        |                        |\n" if i%9==0
		puts "---------------------------------------------------------------------------" if i%27==0
		i+=1
	end
end


def board_is_done?
	i = 1
	while i < 82
		return false if $board[i].kind_of?(Array)
		i+=1
	end
	true
end

def error_found?
	return false unless board_is_done?

	error_found = false

	i = 1
	while i < 82
		if $board[i].nil? || $board[i] == 0
			error_found = true
		end
		i+=1
	end

	if error_found
		start_over
	end

	return error_found
end

def start_over
	$board = Array.new(82, 0)
	calculate_options_for_empty_fields
	puts "** Had to start over to succeed **"
end

def assign_number i, val
	# assign in the field
	val = val.first if val.kind_of?(Array)

	$board[i] = val

	msg = "Assigned #{val} at #{i}; "

	# find box col and row for field
	row = correct_box_col_or_row $rows, i
	col = correct_box_col_or_row $cols, i
	box = correct_box_col_or_row $boxes, i

	# delete value from box, cols, rows
	$boxes[box].each do |x|
		if $board[x].kind_of?(Array) && $board[x].include?(val)
			$board[x].delete(val)
			msg += "deleted #{val} at #{x}; "
		end
	end
	$cols[col].each do |x|
		if $board[x].kind_of?(Array) && $board[x].include?(val)
			$board[x].delete(val)
			msg += "deleted #{val} at #{x}; "
		end
	end
	$rows[row].each do |x|
		if $board[x].kind_of?(Array) && $board[x].include?(val)
			$board[x].delete(val)
			msg += "deleted #{val} at #{x}; "
		end
	end

	true
end

def look_for_single_numbers_in_an_array
	i = 1
	while i < 82
		if $board[i].kind_of?(Array) && $board[i].length == 1
			val = $board[i].first if $board[i].kind_of?(Array)
			assign_number(i, val)
			return true
		end
		i+=1
	end
	false
end

def numbers_with_only_one_possible_destination

	# here we can assume all single numbers have been arranged for
	# CHECKING ROWS
	(1..9).each do |r|
		row = $rows[r]
		field_count = Array.new
		field_count[1] = []
		field_count[2] = []
		field_count[3] = []
		field_count[4] = []
		field_count[5] = []
		field_count[6] = []
		field_count[7] = []
		field_count[8] = []
		field_count[9] = []

		row.each do |field|
			if $board[field].kind_of?(Array) 
				$board[field].each do |val|
					field_count[val] << field
				end
			end
		end
		field_count.each_with_index do |fields, number|
			if fields && fields.kind_of?(Array) && fields.count == 1
				assign_number(field_count[number].first, number)
				return true 
			end
		end
	end

	# CHECKING COLS
	(1..9).each do |c|
		col = $cols[c]
		field_count = Array.new
		field_count[1] = []
		field_count[2] = []
		field_count[3] = []
		field_count[4] = []
		field_count[5] = []
		field_count[6] = []
		field_count[7] = []
		field_count[8] = []
		field_count[9] = []

		col.each do |field|
			if $board[field].kind_of?(Array) 
				$board[field].each do |val|
					field_count[val] << field
				end
			end
		end
		field_count.each_with_index do |fields, number|
			if fields && fields.kind_of?(Array) && fields.count == 1
				assign_number(field_count[number].first, number)
				return true 
			end
		end
	end

	# CHECKING BOXES
	(1..9).each do |b|
		box = $boxes[b]
		field_count = Array.new
		field_count[1] = []
		field_count[2] = []
		field_count[3] = []
		field_count[4] = []
		field_count[5] = []
		field_count[6] = []
		field_count[7] = []
		field_count[8] = []
		field_count[9] = []

		box.each do |field|
			if $board[field].kind_of?(Array) 
				$board[field].each do |val|
					field_count[val] << field
				end
			end
		end
		field_count.each_with_index do |fields, number|
			if fields && fields.kind_of?(Array) && fields.count == 1
				assign_number(field_count[number].first, number)
				return true 
			end
		end
	end

	false

end

def still_arrays_left
	i = 1
	while i < 82
		if $board[i].kind_of?(Array) 
			assign_number(i, $board[i].first)
			return true
		end
		i+=1
	end
	false
end

# OK Return als bord klaar (geen arrays meer)

# OK Eerstvolgende array met maar 1 getal doorvoeren en opnieuw

# Eerstvolgende block row col met getal dat maar op 1 plek kan? Fix door de rest te deleten en start opnieuw 

# OK Eerstvolgende array pakken en 1e waarde doorvoeren en bij de rest deleten en opnieuw


def populate_board 

	populate_board if error_found?

	populate_board if look_for_single_numbers_in_an_array

	populate_board if numbers_with_only_one_possible_destination

	populate_board if still_arrays_left

end


def correct_box_col_or_row arr, field_nr
	i = 1
	while i < 10
		return i if arr[i].include?field_nr
		i+=1
	end
end

def calculate_options_for_empty_fields
	i = 1
	while i < 82
		if $board[i] == 0
			field_options = Array.new($std_seq).shuffle
			box = correct_box_col_or_row($boxes, i)
			col = correct_box_col_or_row($cols, i)
			row = correct_box_col_or_row($rows, i)
			# add boxcolrow and loop once?
			$boxes[box].each do |x|
				if $board[x] != 0 && !$board[x].kind_of?(Array)
					field_options.delete($board[x])
				end
			end
			$cols[col].each do |x|
				if $board[x] != 0 && !$board[x].kind_of?(Array)
					field_options.delete($board[x])
				end
			end
			$rows[row].each do |x|
				if $board[x] != 0 && !$board[x].kind_of?(Array)
					field_options.delete($board[x])
				end
			end
			$board[i] = field_options
			#puts "Options for field #{i} are #{field_options}"
		end
		i+=1
	end
end