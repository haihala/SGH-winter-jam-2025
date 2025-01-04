extends CharacterBody2D

signal death

var holding: Item.Type
var health: int = 3
var money: int = 0
var movement_input: Vector2 = Vector2.ZERO
var ammo: int = -1

@export var player_index: int = 0
@export var speed: float = 1000
@export var rotation_speed: float = 0.2
@export var on_hit_knockback: float = 800

@onready var attack_scene: PackedScene = load("res://attacks/attack.tscn")
@onready var hud_scene: PackedScene = load("res://player/player_hud.tscn")
var player_color: Color = Color.BLACK

func _ready() -> void:
	match player_index:
		-1: player_color = Color.NAVY_BLUE
		0: player_color = Color.DARK_ORANGE
		1: player_color = Color.DARK_GREEN
		2: player_color = Color.MEDIUM_VIOLET_RED
		3: player_color = Color.DARK_RED
	$Sprite2D.material.set_shader_parameter("player_color", player_color)
	var hud = hud_scene.instantiate()
	hud.init(self)
	get_parent().add_child.call_deferred(hud)

func _physics_process(_delta: float) -> void:
	if player_index == -1:
		read_keyboard_input()

	move_and_slide()
	if $KnockdownCooldown.is_stopped():
		velocity = movement_input * speed

	if not velocity.is_zero_approx():
		face_forward()

func read_keyboard_input():
	movement_input = Input.get_vector("kb_left", "kb_right", "kb_up", "kb_down")
	
	if Input.is_action_just_pressed("kb_attack"):
		attack()

	if Input.is_action_just_pressed("kb_interact"):
		money += 1

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

		ammo -= 1
		if ammo == 0:	# -1 ammo means infinite
			holding = Item.Type.NONE
		$AttackSound.play(0.0)

func spawn_attack(scene: PackedScene, attached: bool) -> void:
	var instance = scene.instantiate()
	
	var placement_offset = 30
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
	ammo = Item.ammo_for(item_type)

func take_damage(damaging_attack):
	health -= 1
	if health <= 0:
		death.emit(player_index)
	else:
		$KnockdownCooldown.start()
		var angle = damaging_attack.global_transform.get_rotation()
		velocity = on_hit_knockback * Vector2.from_angle(angle)
