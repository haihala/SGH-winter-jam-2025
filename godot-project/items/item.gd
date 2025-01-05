class_name Item

enum Type {NONE, SWORD, GUN, MONEY}

static func get_texture(type: Type) -> Texture:
	match type:
		Type.GUN:
			return load("res://items/gun-sprite.tres")
		Type.SWORD:
			return load("res://items/sword-sprite.tres")
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

	# Infinite
	return -1
