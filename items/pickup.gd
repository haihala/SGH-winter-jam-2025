extends Node

@export var item_type: Item.Type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = Item.get_texture(item_type)
	$Area2D.connect("body_entered", collision)

func collision(player):
	# Layers should be set up in a way where it can only collide with players
	player.pick_up(item_type)
	get_tree().queue_delete(self)
