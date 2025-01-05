extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func setup() -> Array[Vector2]:
	var spawner_scene = load("res://items/spawner.tscn")
	var vending_scene = load("res://items/vending_machine.tscn")
	var spawn_points: Array[Vector2] = []
	for coords in get_used_cells():
		var td = get_cell_tile_data(coords)
		var tile_position = scale * (Vector2(coords) + Vector2(0.5, 0.5)) * Vector2(tile_set.tile_size)
		
		if td.get_custom_data("basic_item_spawner"):
			erase_cell(coords)
			
			var spawner = spawner_scene.instantiate()
			spawner.position = tile_position
			spawner.scale *= scale
			get_parent().add_child(spawner)
			
		elif td.get_custom_data("player_spawner"):
			erase_cell(coords)
			
			spawn_points.push_back(tile_position)
		elif td.get_custom_data("shotgun_vending_machine"):
			erase_cell(coords)
			
			var machine = vending_scene.instantiate()
			machine.position = tile_position
			machine.scale *= scale
			machine.item_type = Item.Type.SHOTGUN
			machine.cost = 3
			get_parent().add_child(machine)

		elif td.get_custom_data("machinegun_vending_machine"):
			erase_cell(coords)
			
			var machine = vending_scene.instantiate()
			machine.position = tile_position
			machine.scale *= scale
			machine.item_type = Item.Type.MACHINEGUN
			machine.cost = 2
			get_parent().add_child(machine)

		elif td.get_custom_data("health_vending_machine"):
			erase_cell(coords)
		
			var machine = vending_scene.instantiate()
			machine.position = tile_position
			machine.scale *= scale
			machine.item_type = Item.Type.HEART
			machine.cost = 1
			get_parent().add_child(machine)
			
	return spawn_points
