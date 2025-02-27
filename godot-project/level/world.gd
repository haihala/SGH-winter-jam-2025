extends Node2D
@export var player_prefab: PackedScene
@export var card_hud_prefab:  PackedScene
@export var float_hud_prefab: PackedScene
@export var pickup_scene: PackedScene

@export var player_hud_container: Control
@export var timer_label: Label

var spawn_points: Array[Vector2] = []
var players = {}
var huds = {}

func _ready() -> void:
	spawn_points = $TileMapLayer.setup()

	setup_huds()

	Globals.player_scores = {}
	for index in range(Globals.player_handles.size()):
		Globals.player_scores[Globals.player_handles[index]] = 0
		spawn_player(Globals.player_handles[index], spawn_points[index])

func _process(_delta: float) -> void:
	var seconds = int(ceil($Timer.time_left))
	var minutes = seconds / 60
	var leftover_seconds = seconds - (minutes * 60)
	timer_label.text = "%02d:%02d" % [minutes, leftover_seconds]

func timeout() -> void:
	get_tree().change_scene_to_file("res://menus/end_screen/end_screen.tscn")

func player_death(dying_player_index, killer_index) -> void:
	Globals.player_scores[killer_index] += 1
	huds[killer_index].update_score(
		Globals.player_scores[killer_index]
	)

	var pickup = pickup_scene.instantiate()
	pickup.item_type = Item.Type.MONEY
	pickup.position = players[dying_player_index].position
	add_child.call_deferred(pickup)

	huds[dying_player_index].update_money(0)

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
	player.new_held_item.connect(huds[player_index].update_held_item)
	players[player_index] = player
	add_child.call_deferred(player)
	
	var float_hud = float_hud_prefab.instantiate()
	float_hud.player = player
	player.update_money_ui.connect(float_hud.update_money)
	add_child.call_deferred(float_hud)

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
		var player_card = card_hud_prefab.instantiate()
		player_card.init(label_number)
		label_number += 1
		huds[handle] = player_card
		player_hud_container.add_child(player_card)
