require_relative 'sudoku_methods'

puts "\n\n *** GENERATING A VALID SUDOKU BOARD *** "


# CREATE THE board
create_board

# CALCULATE OPTIONS FOR ALL OTHER FIELDS
calculate_options_for_empty_fields

populate_board

print_board





