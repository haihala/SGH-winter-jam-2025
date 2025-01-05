class_name Globals

static var player_handles: Array[int] = [-1, 0, 1]

static func player_color_for_handle(handle: int) -> Color:
	match handle:
		-1: return Color.NAVY_BLUE
		0: return Color.DARK_ORANGE
		1: return Color.DARK_GREEN
		2: return Color.MEDIUM_VIOLET_RED
		3: return Color.DARK_RED
	return Color.BLACK
