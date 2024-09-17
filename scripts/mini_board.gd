extends Panel

@onready var main = get_node("/root/Main")

var big_x := preload("res://assets/big_x.png")
var big_o := preload("res://assets/big_o.png")

var board : String 
var winner : String
var active : bool
var closed : bool
var focused : bool 
var available_cells = 9
var cells = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	closed = false
	
	var group_number = 1
	for i in $GridContainer.get_children():
		i.add_to_group("cells%s" %str(group_number))
		cells.append(i)
		group_number += 1
	
	SignalBus.cell_chosen.connect(player_turn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !board:
		board = str(get_groups()[0])
	
	if !closed:
		if check_for_winner() || available_cells == 0:
			$ClosedPanel/Sprite2D.texture = big_x if main.is_player_x else big_o
			$ClosedPanel.visible = true
			closed = true
			
		if focused:
			$FocusPanel.visible = true
			$LockedPanel.visible = false
		else: 
			$FocusPanel.visible = false
			$LockedPanel.visible = true
	
	if closed:
		$FocusPanel.visible = false

# Called upon player choosing a cell. passes the needed info to Main 
func player_turn(pos):
	if active:
		available_cells -= 1
		SignalBus.player_turn.emit(pos)

# Checks to see if a player has won yet
func check_for_winner():
	if !winner:
		if horizontal_check([0, 3, 6]) || vertical_check([0, 1, 2]) || diagonal_check():
			winner = "player_x" if main.is_player_x else "player_o"
			return true
			
		else: return false

# Checks to see if there are 3 in a row
func horizontal_check(start_index):
	for i in start_index:
		if cells[i].texture_disabled:
			if cells[i].texture_disabled == cells[i + 1].texture_disabled && cells[i + 1].texture_disabled == cells[i + 2].texture_disabled:
				return true

# Checks to see if there are 3 in a column
func vertical_check(start_index):
	for i in start_index:
		if cells[i].texture_disabled:
			if cells[i].texture_disabled == cells[i + 3].texture_disabled && cells[i + 3].texture_disabled == cells[i + 6].texture_disabled:
				return true

# Checks to see if there are 3 in a diagonal
func diagonal_check():
	var winner = false
	if cells[0].texture_disabled:
		if cells[0].texture_disabled == cells[4].texture_disabled && cells[4].texture_disabled == cells[8].texture_disabled:
			winner = true
			
	elif cells[2].texture_disabled:
		if (cells[2].texture_disabled == cells[4].texture_disabled && cells[4].texture_disabled == cells[6].texture_disabled):
			winner = true
	return winner

# Changes the color of the focus panel
func set_focus_panel_color(color):
	var style_box: StyleBoxFlat = $FocusPanel.get_theme_stylebox("panel")
	
	style_box.set("border_color", Color(color))
	$FocusPanel.add_theme_stylebox_override("panel", style_box)

# Activates board when mouse enters
func _on_mouse_entered() -> void:
	if focused:
		active = true

# Deactivates board when mouse exits
func _on_mouse_exited() -> void:
	active = false
