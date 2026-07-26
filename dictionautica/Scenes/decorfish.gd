extends Node2D

var charge: float = 0
var interval: float = 1

var shadowfish = preload("res://Scenes/shadowfish.tscn")
var fish_array : Array[Node] = []

func _physics_process(delta: float) -> void:
	charge+= delta
	if charge > interval:
		var newfish = shadowfish.instantiate()
		add_child(newfish)
		newfish.init()
		newfish.position.x = -50
		newfish.position.y = randf_range(200, 200 + 720*3)
		charge = 0
		fish_array.append(newfish)
	for fish in fish_array:
		fish.position.x += delta*100
		if fish.position.x > 1600:
			fish_array.erase(fish)
			fish.queue_free()
	print(fish_array)		
