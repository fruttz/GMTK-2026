extends Node2D

var possible_letters  = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var letter
var value
var sprite
var dragging = false
var click_radius = 120

func init(l : String):
	if l.to_upper() in possible_letters:
		letter = l.to_upper()
		value = 1
		$Sprite/Label.text = letter

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - $Sprite.position).length() < click_radius:
			if not dragging and event.is_pressed():
				dragging = true
		if dragging and not event.is_pressed():
			dragging = false
	if event is InputEventMouseMotion and dragging:
		$Sprite.position = event.position
	
