extends "res://Scripts/letterfish.gd"


func init():
	type = types.MOLA
	letter= ["BLE", "IAL", "EST", "FUL", "ING", "ION", "ITY", "IVE", "ESS", "OUS"].pick_random()
	$Sprite/Label.text = letter
