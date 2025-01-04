extends Node2D

func _ready():
	spawn_players([-1, 0, 1, 2])

func spawn_players(indices: Array[int]):
	var prefab = load("res://player/player.tscn")
	for index in range(indices.size()):
		var point = $SpawnPoints.get_children()[index]
		var player_index = indices[index]
		var player = prefab.instantiate()
		player.player_index = player_index
		player.position = point.global_position
		player.look_at(Vector2.ZERO)
		add_child(player)
