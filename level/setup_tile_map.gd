extends TileMapLayer

@onready var player_prefab = load("res://player/player.tscn")

# Called when the node enters the scene tree for the first time.
func setup(player_indices: Array) -> void:
	var spawner_scene = load("res://items/spawner.tscn")
	var player_index = 0
	
	for coords in get_used_cells():
		var td = get_cell_tile_data(coords)
		var tile_position = (Vector2(coords) + Vector2(0.5, 0.5)) * Vector2(tile_set.tile_size)
		
		if td.get_custom_data("basic_item_spawner"):
			var spawner = spawner_scene.instantiate()
			spawner.position = tile_position
			# Offset because origins
			add_child(spawner)
			erase_cell(coords)
		elif td.get_custom_data("player_spawner"):
			var player = player_prefab.instantiate()
			player.player_index = player_indices[player_index]
			player_index += 1
			player.position = tile_position * scale
			player.look_at(Vector2.ZERO)
			get_tree().root.add_child.call_deferred(player)
			erase_cell(coords)
