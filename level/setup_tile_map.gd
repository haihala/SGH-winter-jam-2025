extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spawner_scene = load("res://items/spawner.tscn")
	
	for coords in get_used_cells():
		var td = get_cell_tile_data(coords)
		if td.get_custom_data("basic_item_spawner"):
			var spawner = spawner_scene.instantiate()
			# Offset because origins
			spawner.position = (Vector2(coords) + Vector2(0.5, 0.5)) * Vector2(tile_set.tile_size)
			add_child(spawner)
			erase_cell(coords)
