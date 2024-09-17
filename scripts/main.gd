extends Node

var is_player_x : bool
var color_x : String
var color_o : String

var boards = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_player_x = false
	
	var group_number = 1
	for i in $MainBoard/GridContainer.get_children():
		boards.append(i)
		i.add_to_group("board%s" %str(group_number))
		group_number += 1
		i.focused = true
	
	SignalBus.player_turn.connect(take_turn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var color = "#990030" if !is_player_x else "#546d8e"
	
	if check_for_winner():
		get_tree().paused = true
	
	for b in boards:
		if b.focused && b.closed:
			focus_remaining()
		else: b.set_focus_panel_color(color)
	

# Uses the cell position provided to focus on the correct mini board. Also switches the active player
func take_turn(cell_pos):
	for b in boards:
		b.focused = false
	
	var next_board = boards[int(cell_pos[5]) - 1]
	if next_board.closed:
		focus_remaining()
	else: next_board.focused = true
	
	is_player_x = !is_player_x

# Checks to see if either player has won the big board
func check_for_winner():
	if horizontal_check([0, 3, 6]) || vertical_check([0, 1, 2]) || diagonal_check():
		return true
	
	else: return false

# Checks to see if there are 3 in a row
func horizontal_check(start_index):
	for i in start_index:
		if boards[i].winner:
			if boards[i].winner == boards[i + 1].winner && boards[i + 1].winner == boards[i + 2].winner:
				return true

# Checks to see if there are 3 in a column
func vertical_check(start_index):
	for i in start_index:
		if boards[i].winner:
			if boards[i].winner == boards[i + 3].winner && boards[i + 3].winner == boards[i + 6].winner:
				return true

# Checks to see if there are 3 in a diagonal
func diagonal_check():
	var winner = false
	if boards[0].winner:
		if boards[0].winner == boards[4].winner && boards[4].winner == boards[8].winner:
			winner = true
			
	elif boards[2].winner:
		if (boards[2].winner == boards[4].winner && boards[4].winner == boards[6].winner):
			winner = true
	return winner

# Loops through the boards and focuses all that are not closed
func focus_remaining():
	for b in boards:
		if !b.closed:
			b.focused = true
