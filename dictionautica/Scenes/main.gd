extends Node2D

var possible_letters  = ["A", "B", "C", "D"]
var letter_scene = preload("res://Scenes/Letters.tscn")


func add_letters(l: String, position: Vector2):
	var letter = letter_scene.instantiate()
	letter.position = position
	letter.init(l)
	add_child(letter)
	
func _ready() -> void:
	$Letters.init("A")
	$Letters2.init("B")
		
		
	
			
