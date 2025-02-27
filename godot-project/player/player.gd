extends CharacterBody2D

class_name Player

signal death
signal update_money_ui
signal new_held_item

var holding: Item.Type
var max_health: int = 3
var health: int = max_health
var money: int = 0
var movement_input: Vector2 = Vector2.ZERO
var ammo: int = -1
var interactables_in_range: Array[Node] = []
var interact_target: Node2D

var player_index: int = 0
var speed: float = 1000
var rotation_speed: float = 0.2
var on_hit_knockback: float = 800

var max_sprite_shake = 0.3
var sprite_shake = 0.0
var sprite_shake_decay = 1.0
var sprite_shake_speed = 4200.0


@onready var attack_scene: PackedScene = load("res://attacks/attack.tscn")
var player_color: Color

func _ready() -> void:
	player_color = Globals.player_color_for_handle(player_index)
	$Sprite.material.set_shader_parameter("player_color", player_color)

func _physics_process(delta: float) -> void:
	if player_index == -1:
		read_keyboard_input()

	move_and_slide()
	if $KnockdownCooldown.is_stopped():
		velocity = movement_input * speed
		if holding == Item.Type.SWORD:
			# Everyone knows you run faster with a knife
			velocity *= 1.2

	if not velocity.is_zero_approx():
		face_forward()
	update_interact_target()
	update_sprite_shake(delta)

func read_keyboard_input():
	movement_input = Input.get_vector("kb_left", "kb_right", "kb_up", "kb_down")

	if Input.is_action_just_pressed("kb_attack"):
		attack()
	
	if Input.is_action_just_pressed("kb_interact"):
		interact()

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

	if event.is_action_pressed("joy_interact"):
		interact()

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
			Item.Type.SHOTGUN:
				spawn_attack(false, -PI/4)
				spawn_attack(false, -PI/8)
				spawn_attack(false)
				spawn_attack(false, PI/8)
				spawn_attack(false, PI/4)

			Item.Type.MACHINEGUN:
				shoot_burst()

			Item.Type.PISTOL:
				spawn_attack(false)

			Item.Type.LANDMINE:
				spawn_attack(false)

			Item.Type.SWORD:
				spawn_attack(true)

			Item.Type.NONE:
				spawn_attack(true)

		ammo -= 1
		if ammo == 0:	# -1 ammo means infinite
			holding = Item.Type.NONE
			new_held_item.emit(holding)

func shoot_burst() -> void:
	for _i in range(5):
		spawn_attack(false)
		await get_tree().create_timer(0.1).timeout

func spawn_attack(attached: bool, angle_offset: float = 0) -> void:
	var instance = attack_scene.instantiate()
	
	var placement_offset = 30
	var host = null
	
	if attached:
		host = self
		instance.position.x = placement_offset * cos(angle_offset)
		instance.position.y = placement_offset * sin(angle_offset)
	else:
		host = get_parent()
		var angle = rotation + angle_offset
		
		var look_dir = Vector2(cos(angle), sin(angle))
		instance.position += position + placement_offset * look_dir
		instance.rotation = angle

	host.add_child(instance)
	$AttackCooldown.start(instance.configure(self))
	Item.play_usage_sound(holding, $AttackSound)

func update_interact_target() -> void:
	var closest = null
	var min_dist = INF
	for interactable in interactables_in_range:
		var dist = (position - interactable.position).length()
		if dist < min_dist:
			min_dist = dist
			closest = interactable
	interact_target = closest

func interact() -> void:
	if interact_target != null:
		interact_target.interact(self)

func pick_up(item_type):
	$PickupSound.play()
	if item_type == Item.Type.MONEY:
		money += 1
		update_money_ui.emit(money)
	elif item_type == Item.Type.HEART:
		health += 1
	else:
		holding = item_type
		ammo = Item.ammo_for(item_type)
		new_held_item.emit(holding)

func take_damage(damaging_attack):
	health -= 1
	if health <= 0:
		death.emit(player_index, damaging_attack.player.player_index)
	else:
		$KnockdownCooldown.start()
		$DamageSound.play(0)
		var angle = damaging_attack.global_transform.get_rotation()
		velocity = on_hit_knockback * Vector2.from_angle(angle)
		sprite_shake = max_sprite_shake


func update_sprite_shake(delta: float) -> void:
	var decay = sprite_shake_decay * delta
	if sprite_shake < decay:
		sprite_shake = 0
	else:
		sprite_shake -= decay
	
	var angle = Time.get_unix_time_from_system() * sprite_shake_speed
	$Sprite.offset.x = cos(angle) * sprite_shake
	$Sprite.offset.y = sin(angle) * sprite_shake
