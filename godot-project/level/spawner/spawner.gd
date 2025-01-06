extends Node2D

var item: Node = null
@onready var pickup: PackedScene = load("res://items/pickup.tscn")

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func spawn() -> void:
	item = pickup.instantiate()
	item.item_type = Item.random_pickup()
	item.position = global_position
	get_tree().root.add_child.call_deferred(item)
	item.connect("tree_exiting", reset_timer)
	$AnimatedSprite2D.play("done")

func reset_timer() -> void:
	$AnimatedSprite2D.play("default")
	$Timer.start(5)
