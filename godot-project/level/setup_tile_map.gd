extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func setup() -> Array[Vector2]:
	var spawner_scene = load("res://items/spawner.tscn")
	var spawn_points: Array[Vector2] = []
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
			erase_cell(coords)
			spawn_points.push_back(tile_position * scale)

	return spawn_points
