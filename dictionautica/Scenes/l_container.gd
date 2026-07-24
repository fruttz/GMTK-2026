extends Node2D

var possible_letters  = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
var letter_scene = preload("res://Scenes/Letters.tscn")

func add_letters(l: String, pos: Vector2):
	var letter = letter_scene.instantiate()
	letter.position = pos
	letter.init(l)
	add_child(letter)

func setup():
	var rng = RandomNumberGenerator.new()
	var pos : Vector2
	for l in possible_letters:
		var x = rng.randf_range($Panel.position.x + 64, $Panel.size.x - 64)
		var y = rng.randf_range($Panel.position.y + 64, $Panel.size.y - 64)
		pos.x = x
		pos.y = y
		add_letters(l, pos)
