extends CharacterBody2D

var holding: Item.Type
var health: int = 10
var movement_input: Vector2 = Vector2.ZERO

@export var player_index: int = 0
@export var speed: float = 1000
@export var rotation_speed: float = 0.2

@onready var attack_scene: PackedScene = load("res://items/attack.tscn")

func _physics_process(_delta: float) -> void:
	if player_index == -1:
		read_keyboard_input()

	velocity = movement_input * speed
	move_and_slide()
	
	
	if not velocity.is_zero_approx():
		face_forward()

func read_keyboard_input():
	movement_input = Input.get_vector("kb_left", "kb_right", "kb_up", "kb_down")
	
	if Input.is_action_just_pressed("kb_attack"):
		attack()

func _input(event):
	if event.device != player_index || event.is_echo():
		return
	
	# This is a bit ugly, but I think this is the cleanest way for local multiplayer
	# On an analog stick, inputs on an axis register as **both** the positive and negative action
	if event.is_action("joy_up") || event.is_action("joy_down"):
		movement_input.y = event.get_action_strength("joy_down") - event.get_action_strength("joy_up")
	if event.is_action("joy_left") || event.is_action("joy_right"):
		movement_input.x = event.get_action_strength("joy_right") - event.get_action_strength("joy_left")
	
	if event.is_action_pressed("joy_attack"):
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
	if $AttackCooldown.is_stopped():
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
	$AttackCooldown.start(instance.configure(self))

func pick_up(item_type):
	holding = item_type
