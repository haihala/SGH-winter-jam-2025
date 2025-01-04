extends Node2D

func _ready():
	print(Globals.player_handles)
	$TileMapLayer.setup(Globals.player_handles)
