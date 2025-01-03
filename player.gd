extends CharacterBody2D

@export var speed: float = 300

func _physics_process(delta: float) -> void:
	var movement_input = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")	# Positive y is down
	)
	
	velocity = movement_input * speed
	move_and_slide()
