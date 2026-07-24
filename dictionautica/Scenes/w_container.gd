extends Node2D

var bodies = []

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
	
func _on_submit_button_down() -> void:
	if read_letters() in compare_dict():
		print(read_letters())
		for b in bodies:
			b.queue_free()
	else:
		print("Not a Word!")
		
		
	
