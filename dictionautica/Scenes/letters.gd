extends Node2D

var letter
var value
var sprite
var dragging = false
var click_radius = 64

func init(l : String, type: String):
	letter = l.to_upper()
	value = 1
	$Sprite/Letter.text = letter
	if type == "letta":
		$Sprite.texture = load("res://Sprites/Game Jam/Fish Regular/LettaLetta.png")
		$Sprite/Letter.self_modulate = Color.from_rgba8(107, 141, 88)
	if type == "suffish":
		$Sprite.texture = load("res://Sprites/Game Jam/Fish Regular/Suffish.png")
		$Sprite/Letter.self_modulate = Color.from_rgba8(181, 73, 77)
	if type == "andies":
		$Sprite.texture = load("res://Sprites/Letter_Tiles.webp")
		$Sprite.scale = $Sprite.scale * 3
		$Sprite/Letter.self_modulate = Color.from_rgba8(47, 127, 153)

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
		if position.x <= 0:
			position.x = 0 + 100
		if position.x >= 1280:
			position.x = 1280 - 100
		if position.y <= 0:
			position.y = 0 
		if position.y >= 720:
			position.y = 720 - 50	
	
