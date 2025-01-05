extends MarginContainer

@export var player_label: Label
@export var money_label: Label
@export var score_label: Label

func init(player_index: int) -> void:
	player_label.text = "Player %s" % (player_index + 1)
	var color = Globals.player_color_for_handle(
		Globals.player_handles[player_index]
	)
	player_label.add_theme_color_override("font_color", color)
	update_money(0)
	update_score(0)

func update_money(money):
	money_label.text = "Money: $%s" % money

func update_score(score):
	score_label.text = "Score: %s" % score
