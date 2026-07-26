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

func clear_letters():
	if !$Letter_Container.get_children().is_empty():
		for c in $Letter_Container.get_children():
			c.queue_free()

func _on_exit_button_down() -> void:
	self.visible = false
	get_parent().get_node("Submarine/Camera2D").make_current()
	$"..".oxygen = $"..".oxygen_max
	$"..".letter_array.clear()
	clear_letters()
	#maap dit gw nambahin UI code di sini spaghetti jam
	get_parent().show_gauge()
	
