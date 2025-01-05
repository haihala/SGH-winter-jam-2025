extends Node

@export var item_type: Item.Type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = Item.get_texture(item_type)

func collision(player: Player) -> void:
	player.interactables_in_range.push_back(self)

func player_exit(player: Player) -> void:
	if self in player.interactables_in_range:
		player.interactables_in_range.erase(self)

func interact(player: Player) -> void:
	player.pick_up(item_type)
	get_tree().queue_delete(self)
