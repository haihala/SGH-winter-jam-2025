class_name Item

enum Type {NONE, SWORD, PISTOL, SHOTGUN, MACHINEGUN, LANDMINE, HEART, MONEY}


static func get_texture(type: Type) -> Texture:
	match type:
		Type.PISTOL:
			return load("res://items/pistol-sprite.tres")
		Type.SWORD:
			return load("res://items/sword-sprite.tres")
		Type.SHOTGUN:
			return load("res://items/shotgun-sprite.tres")
		Type.MACHINEGUN:
			return load("res://items/machinegun-sprite.tres")
		Type.LANDMINE:
			return load("res://items/landmine-sprite.tres")
		Type.HEART:
			return load("res://items/heart-sprite.tres")
		Type.MONEY:
			return load("res://items/money-sprite.tres")

	# This should never happen, means a null item is getting a texture
	return load("res://items/missing-sprite.tres")


static func play_usage_sound(type: Type, stream_player: AudioStreamPlayer) -> void:
	match type:
		Type.PISTOL:
			stream_player.stream = load("res://items/pistol.wav")
			stream_player.volume_db = -15
		Type.SWORD:
			stream_player.stream = load("res://items/sword.wav")
			stream_player.volume_db = 1
		Type.SHOTGUN:
			stream_player.stream = load("res://items/shotgun.wav")
			stream_player.volume_db = 5
		Type.MACHINEGUN:
			stream_player.stream = load("res://items/machinegun.wav")
			stream_player.volume_db = 0
		Type.LANDMINE:
			stream_player.stream = load("res://items/landmine.wav")
			stream_player.volume_db = 0
		Type.NONE:
			stream_player.stream = load("res://items/punch.wav")
			stream_player.volume_db = -10

	stream_player.play(0)

static func random_pickup() -> Type:
	return [
		Type.PISTOL,
		Type.SWORD
	].pick_random()

static func ammo_for(type: Type) -> int:
	match type:
		Type.PISTOL:
			return 6
		Type.SHOTGUN:
			return 4
		Type.MACHINEGUN:
			return 5	# Each burst is one shot
		Type.LANDMINE:
			return 1

	# Infinite
	return -1
