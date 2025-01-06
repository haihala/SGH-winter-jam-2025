extends Node2D

@onready var pickup_scene: PackedScene = load("res://items/pickup.tscn")
var distance = 200

func _ready():
	$Sprite.play("ready")


func drop_money(attack):
	if $Sprite.animation == "ready":
		var dir = (attack.player.position - position).normalized();
		var money = pickup_scene.instantiate()
		money.item_type = Item.Type.MONEY
		money.position = dir * distance + position
		get_parent().add_child.call_deferred(money)
		$AudioStreamPlayer.play(0)
		$Sprite.play("regrow")

func refresh():
	$Sprite.play("ready")
	$AudioStreamPlayer.play(0)
