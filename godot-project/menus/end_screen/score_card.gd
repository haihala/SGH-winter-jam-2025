extends MarginContainer

@export var player_label: Label
@export var value_label: Label
var player_index: int

func _ready() -> void:
	player_label.text = "Player %s" % (player_index + 1)
	var player_handle = Globals.player_handles[player_index]
	var color = Globals.player_color_for_handle(player_handle)
	player_label.add_theme_color_override("font_color", color)
	value_label.text = str(Globals.player_scores[player_handle])
