extends TileMapLayer

@onready var vending_scene = load("res://level/vending_machine/vending_machine.tscn")
@onready var spawner_scene = load("res://level/spawner/spawner.tscn")
@onready var tree_scene = load("res://level/tree/tree.tscn")
# Called when the node enters the scene tree for the first time.
func setup() -> Array[Vector2]:

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
			
			spawn_vending_machine(Item.Type.SHOTGUN, 3, tile_position)

		elif td.get_custom_data("machinegun_vending_machine"):
			erase_cell(coords)
			spawn_vending_machine(Item.Type.MACHINEGUN, 2, tile_position)

		elif td.get_custom_data("landmine_vending_machine"):
			erase_cell(coords)
			spawn_vending_machine(Item.Type.LANDMINE, 1, tile_position)

		elif td.get_custom_data("health_vending_machine"):
			erase_cell(coords)
			spawn_vending_machine(Item.Type.HEART, 1, tile_position)

		elif td.get_custom_data("tree_position"):
			erase_cell(coords)
		
			var tree = tree_scene.instantiate()
			tree.position = tile_position
			tree.scale *= scale
			get_parent().add_child(tree)

	return spawn_points

func spawn_vending_machine(item_type: Item.Type, cost: int, pos: Vector2) -> void:
	var machine = vending_scene.instantiate()
	machine.position = pos
	machine.scale *= scale
	machine.item_type = item_type
	machine.cost = cost
	get_parent().add_child(machine)
