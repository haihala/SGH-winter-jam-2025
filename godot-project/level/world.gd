extends Node2D
@onready var player_prefab = load("res://player/player.tscn")
@onready var hud_scene = load("res://player/player_ui.tscn")
@onready var pickup_scene: PackedScene = load("res://items/pickup.tscn")


var spawn_points: Array[Vector2] = []
var players = {}
var huds = {}

func _ready() -> void:
	spawn_points = $TileMapLayer.setup()

	for index in range(Globals.player_handles.size()):
		spawn_player(Globals.player_handles[index], spawn_points[index])

	setup_hud()

func player_death(player_index) -> void:
	var pickup = pickup_scene.instantiate()
	pickup.item_type = Item.Type.MONEY
	pickup.position = players[player_index].position
	get_tree().root.add_child(pickup)
	
	get_tree().queue_delete(players[player_index])
	players.erase(player_index)

	$RespawnSound.play(0)
	spawn_player(player_index, find_open_spawn())

func spawn_player(player_index, point) -> void:
	var player = player_prefab.instantiate()
	player.player_index = player_index
	player.position = point
	player.look_at(Vector2.ZERO)
	player.death.connect(player_death)
	players[player_index] = player
	get_tree().root.add_child.call_deferred(player)

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

func setup_hud() -> void:
	var label_number = 1
	for handle in Globals.player_handles:
		var player_hud = hud_scene.instantiate()
		player_hud.init(label_number)
		label_number += 1
		huds[handle] = player_hud
		$HUD/HBoxContainer/VBoxContainer.add_child(player_hud)
