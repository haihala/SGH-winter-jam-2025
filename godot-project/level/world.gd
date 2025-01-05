extends Node2D
@onready var player_prefab = load("res://player/player.tscn")
@onready var hud_scene = load("res://player/player_ui.tscn")
@onready var pickup_scene: PackedScene = load("res://items/pickup.tscn")
@onready var float_hud_scene: PackedScene = load("res://player/player_hud.tscn")


var spawn_points: Array[Vector2] = []
var players = {}
var huds = {}

func _ready() -> void:
	spawn_points = $TileMapLayer.setup()

	setup_huds()

	for index in range(Globals.player_handles.size()):
		spawn_player(Globals.player_handles[index], spawn_points[index])


func player_death(dying_player_index, killer) -> void:
	killer.score += 1
	huds[killer.player_index].update_score(killer.score)

	var pickup = pickup_scene.instantiate()
	pickup.item_type = Item.Type.MONEY
	pickup.position = players[dying_player_index].position
	get_tree().root.add_child(pickup)
	
	get_tree().queue_delete(players[dying_player_index])
	players.erase(dying_player_index)

	$RespawnSound.play(0)
	spawn_player(dying_player_index, find_open_spawn())

func spawn_player(player_index, point) -> void:
	var player = player_prefab.instantiate()
	player.player_index = player_index
	player.position = point
	player.look_at(Vector2.ZERO)
	player.death.connect(player_death)
	player.update_money_ui.connect(huds[player_index].update_money)
	players[player_index] = player
	get_tree().root.add_child.call_deferred(player)
	
	var float_hud = float_hud_scene.instantiate()
	float_hud.init(player)
	player.update_money_ui.connect(float_hud.update_money)
	get_tree().root.add_child.call_deferred(float_hud)

func find_open_spawn():
	# Finds the one with the most distance to the closest player
	var min_dists = {}
	for point in spawn_points:
		var min_dist = INF
		for pi in players:
			var player = players[pi]
			var dist = (point - player.global_position).length()
			if dist < min_dist:
				min_dist = dist
		min_dists[point] = min_dist

	var selected = null
	var max_min = 0
	for point in min_dists:
		var dist = min_dists[point]
		if dist > max_min:
			max_min = dist
			selected = point
	return selected

func setup_huds() -> void:
	var label_number = 0
	for handle in Globals.player_handles:
		var player_hud = hud_scene.instantiate()
		player_hud.init(label_number)
		label_number += 1
		huds[handle] = player_hud
		$HUD/HBoxContainer/VBoxContainer.add_child(player_hud)
