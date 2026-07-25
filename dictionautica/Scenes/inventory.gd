extends Node2D

signal mission1_upgrade
signal mission2_upgrade
signal mission3_upgrade

func setup(letter_array) -> void:
	$Letter_Container.setup(letter_array)

func set_score(new_score):
	if new_score > $"..".score:
		$"..".offset_score = new_score - $"..".score
		$"..".score -= $"..".score
	else:
		$"..".score -= new_score
	$"../UILayer/Score".text = "Letters to Upgrade: " + str($"..".score)

func get_score():
	return $"..".score

func _on_exit_button_down() -> void:
	self.visible = false
	get_parent().get_node("Submarine/Camera2D").make_current()
	$"..".oxygen = $"..".oxygen_max
