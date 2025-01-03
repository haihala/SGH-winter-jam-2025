extends Node2D

var speed: float = 1

var player: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.connect("body_entered", collision)

func configure(player):
	self.player = player
	match player.holding:
		Item.Type.GUN:
			speed = 20

		Item.Type.SWORD:
			speed = 2
			scale.x = 1.5
			scale.y = 3.0
			$Timer.start()

		Item.Type.NONE:
			$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var look_dir = Vector2(cos(rotation), sin(rotation))
	position += look_dir*speed


func collision(obj) -> void:
	if obj != player:
		print(obj)
		despawn()

func despawn() -> void:
	get_tree().queue_delete(self)
