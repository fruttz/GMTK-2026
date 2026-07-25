extends Node2D

var letter_scene = preload("res://Scenes/Letters.tscn")

func add_letters(l: String, type: String,pos: Vector2):
	var letter = letter_scene.instantiate()
	letter.position = pos
	letter.init(l, type)
	add_child(letter)

func setup(possible_letters):
	var rng = RandomNumberGenerator.new()
	var pos : Vector2
	var type
	for l in possible_letters + ["ING"]:
		var x = rng.randf_range($Letter_Panel.position.x + 64, $Letter_Panel.size.x - 64)
		var y = rng.randf_range($Letter_Panel.position.y + 64, $Letter_Panel.size.y - 64)
		pos.x = x
		pos.y = y
		if l.length() > 1:
			type = "suffish"
		else:
			type = "letta"
		add_letters(l, type, pos)
		
			
			
