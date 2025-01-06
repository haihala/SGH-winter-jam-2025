extends MarginContainer

@export var player_label: Label
@export var money_label: Label
@export var score_label: Label
@export var held_icon: TextureRect

func init(player_index: int) -> void:
	player_label.text = "Player %s" % (player_index + 1)
	var color = Globals.player_color_for_handle(
		Globals.player_handles[player_index]
	)
	player_label.add_theme_color_override("font_color", color)
	update_money(0)
	update_score(0)

func update_money(money: int) -> void:
	money_label.text = "Money: $%s" % money

func update_score(score: int) -> void:
	score_label.text = "Score: %s" % score

func update_held_item(item_type: Item.Type) -> void:
	if item_type == Item.Type.NONE:
		held_icon.visible = false
	else:
		held_icon.texture = Item.get_texture(item_type)
		held_icon.visible = true
