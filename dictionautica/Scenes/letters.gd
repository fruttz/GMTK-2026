extends Node2D

var letter
var value
var sprite
var dragging = false
var click_radius = 64

func init(l : String):
	letter = l.to_upper()
	value = 1
	$Sprite/Letter.text = letter
	$Sprite/Value.text = str(value)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.position - position).length() < click_radius:
			if not dragging and event.is_pressed():
				dragging = true
				self.freeze = true
		if dragging and not event.is_pressed():
			dragging = false
			self.freeze = false
	if event is InputEventMouseMotion and dragging:
		position = event.position
	
	
