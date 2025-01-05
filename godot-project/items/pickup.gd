extends Node

@export var item_type: Item.Type
var delayed_collision: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = Item.get_texture(item_type)
	$Area2D.connect("body_entered", collision)

func _physics_process(_delta: float) -> void:
	if delayed_collision != null && $Timer.is_stopped():
		pick_up(delayed_collision)

func collision(player):
	if $Timer.is_stopped():
		pick_up(player)
	else:
		delayed_collision = player

func pick_up(player: Player) -> void:
	player.pick_up(item_type)
	get_tree().queue_delete(self)
