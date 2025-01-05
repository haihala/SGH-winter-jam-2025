extends VBoxContainer

func init(label_number: int) -> void:
	$Label.text = "Player %s" % label_number
