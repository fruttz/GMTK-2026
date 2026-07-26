extends Sprite2D


func init(): 
	self.texture = [
		preload("res://Sprites/Fish Shiny/Shiny Andy.png"),
		preload("res://Sprites/Fish Shiny/Shiny LettaLetta.png"),
		preload("res://Sprites/Fish Shiny/Shiny Suffish.png")].pick_random()
