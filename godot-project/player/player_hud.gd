extends Node2D

var player = Node2D

@export var money_transparency_speed = 0.5

func init(host):
	player = host
	$HealthSprite.material.set_shader_parameter("max_health", player.health)
	$HealthSprite.material.set_shader_parameter("current_health", player.health)
	$MoneyLabel.modulate.a = 0.0

func _process(delta: float) -> void:
	if not player:
		get_tree().queue_delete(self)
		return;
	position = player.position
	$HealthSprite.material.set_shader_parameter("current_health", player.health)

	$MoneyLabel.modulate.a -= delta*money_transparency_speed

func update_money(value: int) -> void:
	$MoneyLabel.modulate.a = 1.0
	$MoneyLabel.text = "$%s" % value
