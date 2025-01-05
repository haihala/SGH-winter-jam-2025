extends Node2D

class_name VendingMachine

@export var item_type: Item.Type
@export var cost: int
@export var money_sample: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var max_bill_offset = money_sample.position.x

	if cost > 1:
		var per_bill_offset = max_bill_offset * 2 / (cost-1)
		for bill in range(cost):
			spawn_bill_at(-max_bill_offset + per_bill_offset * bill)
	elif cost == 1:
		spawn_bill_at(0)

	$"Item sprite".texture = Item.get_texture(item_type)

func spawn_bill_at(x: float) -> void:
	var dupe = money_sample.duplicate()
	dupe.position.x = x
	dupe.visible = true
	add_child(dupe)

func buy_from() -> void:
	$AudioStreamPlayer.play(0)

func player_enter(player) -> void:
	player.machines_in_range.push_back(self)

func player_exit(player) -> void:
	if self in player.machines_in_range:
		player.machines_in_range.erase(self)
