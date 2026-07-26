extends Node2D

var bodies = []
var mission1 = false
var mission2 = false
var mission3 = false

func _on_area_2d_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	bodies.append(body)

func _on_area_2d_body_shape_exited(_body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body != null:
		var removed_instance_id = body.get_instance_id()
		for b in bodies:
			if b.get_instance_id() == removed_instance_id:
				bodies.erase(b)

func compare_dict():
	var file = FileAccess.open("res://Scripts/dictionary.txt", FileAccess.READ)
	var content = file.get_as_text().split("\n")
	return content

func read_letters():
	var letters = []
	bodies.sort_custom(func(b1, b2): return b1.position.x < b2.position.x)
	for b in bodies:
		letters.append(b.letter)
	var word = "".join(letters)
	return word

func check_adjacent_duplicate(array):
	for e in range(0, array.size() - 1):
		if array[e] == array[e+1]:
			return true
	return false
	
func _on_submit_button_down() -> void:
	var word = read_letters()
	var word_array = word.split("")
	if word in compare_dict():
		if !mission1 and word_array.size() >= 7:
			mission1 = true
			print("mission 1 accomplished")
			$"..".mission1_upgrade.emit()
		elif !mission2 and check_adjacent_duplicate(word_array):
			mission2 = true
			print("mission 2 accomplished")
			$"..".mission2_upgrade.emit()
		elif !mission3 and word_array[0] in ["J", "X", "Q", "Z"]:
			print("mission 3 accomplished")
			mission3 = true
			$"..".mission3_upgrade.emit()
		get_parent().set_score(word_array.size())
		for b in bodies:
			b.modulate = Color.GOLD
			b.score_anim()
			await b.get_node("AnimationPlayer").animation_finished
		for b in bodies:
			b.queue_free()
	else:
		print("Not a Word!")
		
		
	
