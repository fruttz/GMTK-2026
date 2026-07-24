extends Node2D
	
	
func setup(letter_array) -> void:
	$Letter_Container.setup(letter_array)

func _on_exit_button_down() -> void:
	self.visible = false
	get_parent().get_node("Submarine/Camera2D").make_current()
