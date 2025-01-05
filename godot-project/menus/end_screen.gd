extends HBoxContainer

@export var score_container: Control
@onready var player_card: PackedScene = load("res://menus/score_card.tscn")

func _ready() -> void:
	var sorted_handles = Globals.player_handles.duplicate()
	sorted_handles.sort_custom(ord)
	
	for player in sorted_handles:
		var index = Globals.player_handles.find(player)
		var card = player_card.instantiate()
		card.player_index = index
		score_container.add_child(card)

func ord(a, b):
	return Globals.player_scores[a] > Globals.player_scores[b]

func to_main_menu() -> void:
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
