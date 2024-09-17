extends TextureButton

@onready var main = get_node("/root/Main")

var x_pic := preload("res://assets/x.png")
var o_pic := preload("res://assets/o.png")

func _process(delta: float) -> void:
	pass

func draw_pic(x_turn):
	var pic
	if x_turn:
		pic = x_pic
	else: pic = o_pic
	
	texture_disabled = pic

func _on_toggled(toggled_on: bool) -> void:
	SignalBus.cell_chosen.emit(str(get_groups()[0]))
	draw_pic(main.is_player_x)
	set_disabled(true)
