class_name Item

enum Type {NONE, SWORD, GUN, SHOTGUN, HEART, MONEY}

static func get_texture(type: Type) -> Texture:
	match type:
		Type.GUN:
			return load("res://items/pistol-sprite.tres")
		Type.SWORD:
			return load("res://items/sword-sprite.tres")
		Type.SHOTGUN:
			return load("res://items/shotgun-sprite.tres")
		Type.HEART:
			return load("res://items/heart-sprite.tres")
		Type.MONEY:
			return load("res://items/money-sprite.tres")

	# This should never happen, means a null item is getting a texture
	return load("res://items/missing-sprite.tres")

static func random_pickup() -> Type:
	return [
		Type.GUN,
		Type.SWORD
	].pick_random()

static func ammo_for(type: Type) -> int:
	match type:
		Type.GUN:
			return 6
		Type.SHOTGUN:
			return 4
	# Infinite
	return -1
