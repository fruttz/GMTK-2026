extends "res://Scripts/letterfish.gd"

func init():
	type = types.SUFFISH
	letter= ["BLE", "IAL", "EST", "FUL", "ING", "ION", "ITY", "IVE", "ESS", "OUS"].pick_random()
	$Sprite/Label.text = letter
