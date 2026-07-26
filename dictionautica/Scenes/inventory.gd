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

func get_num_of_fish():
	return $Letter_Container.get_children().size()

func clear_letters():
	if !$Letter_Container.get_children().is_empty():
		for c in $Letter_Container.get_children():
			c.clear_anim()
		await $Letter_Container.get_children()[0].get_node("AnimationPlayer").animation_finished
		for c in $Letter_Container.get_children():
			c.queue_free()
		
func _on_exit_button_down() -> void:
	clear_letters()
	await get_tree().create_timer(1).timeout
	self.visible = false
	get_parent().get_node("Submarine/Camera2D").make_current()
	$"..".oxygen = $"..".oxygen_max
	$"..".letter_array.clear()
	
