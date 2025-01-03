extends CharacterBody2D

var health: int = 10
@export var speed: float = 1000
@export var rotation_speed: float = 0.2

func _physics_process(delta: float) -> void:
	var movement_input = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")	# Positive y is down
	)
	
	velocity = movement_input * speed
	move_and_slide()
	
	if not velocity.is_zero_approx():
		var look_dir = Vector2(cos(rotation), sin(rotation))
		var angle = look_dir.angle_to(velocity)
			
		if abs(angle) < rotation_speed:
			look_at(position+velocity)
		else:
			# Gradually turn
			var angle_sign = 1 if angle > 0 else -1
			rotate(angle_sign * rotation_speed)
