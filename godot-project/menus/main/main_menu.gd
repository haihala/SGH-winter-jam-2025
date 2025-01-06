extends Control

func go_to_controller_select() -> void:
	get_tree().change_scene_to_file("res://menus/device_selection/device_selection.tscn")

func go_to_tutorial() -> void:
	get_tree().change_scene_to_file("res://menus/tutorial/tutorial.tscn")

func quit_to_desktop() -> void:
	get_tree().quit()
