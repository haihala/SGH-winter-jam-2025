class_name Item

enum Type {NONE, SWORD, GUN}

static func get_texture(type: Type) -> Texture:
	match type:
		Type.GUN:
			return load("res://items/gun-sprite.tres")
		Type.SWORD:
			return load("res://items/sword-sprite.tres")

	# This should never happen, means a null item is getting a texture
	return load("res://items/missing-sprite.tres")
