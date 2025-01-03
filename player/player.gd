extends CharacterBody2D

var holding: Item.Type
var health: int = 10

@export var speed: float = 1000
@export var rotation_speed: float = 0.2

@onready var attack_scene: PackedScene = load("res://items/attack.tscn")

func _physics_process(_delta: float) -> void:
	var movement_input = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")	# Positive y is down
	)
	
	velocity = movement_input * speed
	move_and_slide()
	
	if not velocity.is_zero_approx():
		face_forward()
	
	if Input.is_action_just_pressed("attack"):
		attack()


func face_forward():
	var look_dir = Vector2(cos(rotation), sin(rotation))
	var angle = look_dir.angle_to(velocity)
		
	if abs(angle) < rotation_speed:
		look_at(position+velocity)
	else:
		# Gradually turn
		var angle_sign = 1 if angle > 0 else -1
		rotate(angle_sign * rotation_speed)

func attack():
	
	match holding:
		Item.Type.GUN:
			spawn_attack(attack_scene, false)
		Item.Type.SWORD:
			spawn_attack(attack_scene, true)
		Item.Type.NONE:
			spawn_attack(attack_scene, true)

func spawn_attack(scene: PackedScene, attached: bool) -> void:
	var instance = scene.instantiate()
	
	var placement_offset = 50
	var host = null
	
	if attached:
		host = self
		instance.position.x = placement_offset
	else:
		host = get_parent()
		
		var look_dir = Vector2(cos(rotation), sin(rotation))
		instance.position += position + placement_offset * look_dir
		instance.rotation = rotation

	host.add_child(instance)
	instance.configure(self)

func pick_up(item_type):
	holding = item_type
