extends VBoxContainer

var device: int
var container: Node
var selected = false 

func setup(dev, cont) -> void:
	device = dev
	container = cont
	
	if dev >= 0:
		$Label.text = "Controller %s" % (dev + 1)
	set_state(false)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		container.return_to_main_menu()

	if device >= 0:
		return
	
	# Keyboard events
	if Input.is_action_just_pressed("kb_left"):
		set_state(false)
	elif Input.is_action_just_pressed("kb_right"):
		set_state(true)
	elif Input.is_action_just_pressed("kb_attack"):
		container.start_game()


func _input(event: InputEvent) -> void:
	if device != event.device || event.is_echo():
		return

	# Gamepad events, can't use ui_accept or keyboard controls controller 0
	if Input.is_action_pressed("joy_left"):
		set_state(false)
	elif Input.is_action_pressed("joy_right"):
		set_state(true)
	elif Input.is_action_pressed("joy_attack"):
		container.start_game()

func set_state(new_state):
	selected = new_state
	container.selection_update(device, selected)
	
	var selected_index = int(selected)
	for child_index in range(2):
		var child = $Icons.get_child(child_index)
		if selected_index == child_index:
			child.modulate.a = 1.0
			child.scale = Vector2(1.0, 1.0)
		else:
			child.modulate.a = 0.5
			child.scale = Vector2(0.6, 0.6)
