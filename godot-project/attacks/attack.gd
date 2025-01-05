extends Node2D

var speed: float = 1

var player: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.connect("body_entered", collision)

# Returns attack cooldown
# This way the entire attack data stays in one place
func configure(shooter) -> float:
	self.player = shooter
	$Sprite2D.material.set_shader_parameter("player_color", shooter.player_color)
	match shooter.holding:
		Item.Type.SHOTGUN:
			speed = 20
			return 0.5

		Item.Type.MACHINEGUN:
			speed = 30
			return 1.0

		Item.Type.GUN:
			speed = 40
			return 0.1

		Item.Type.SWORD:
			speed = 2
			scale.x = 2.0
			scale.y = 3.0
			position.x = 100
			$Timer.start()
			return 1.0

		Item.Type.NONE:
			$Timer.start()
			return 0.8

	return 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var look_dir = Vector2(cos(rotation), sin(rotation))
	position += look_dir*speed


func collision(obj) -> void:
	if obj != player:
		if obj.has_method("take_damage"):
			obj.take_damage(self)
		despawn()

func despawn() -> void:
	get_tree().queue_delete(self)
