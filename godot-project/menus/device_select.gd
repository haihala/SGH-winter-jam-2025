extends Control

var devices = {-1: false}

@export var error_message: Node

func _ready() -> void:
	for controller in Input.get_connected_joypads():
		devices[controller] = false

	var selector_prefab = load("res://menus/device_selector.tscn")
	for dev in devices:
		var selector = selector_prefab.instantiate()
		selector.setup(dev, self)
		$Layout/DeviceContainer.add_child(selector)

func selection_update(device, value) -> void:
	devices[device] = value

func start_game() -> void:
	var players: Array[int] = []
	for dev in devices:
		if devices[dev]:
			players.push_back(dev)
	
	if players.size() == 0 || players.size() > 4:
		error_message.visible = true
	else:
		Globals.player_handles = players
		get_tree().change_scene_to_file("res://level/world.tscn")

func return_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
