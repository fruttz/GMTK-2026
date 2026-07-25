extends "res://Scripts/suffish.gd"

var andy_types : Array[int] = []
var andy_letters : Array[String] = []
func init():
	is_andies = true
	andy_types = [types.ANDY, types.ANDY, types.ANDY]
	var labels : Array[Node] = [$Sprite/Label,$Sprite2/Label,$Sprite3/Label]
	for i in [0,1,2]:
		var letter = ["A", "E", "I", "L", "N", "O", "R", "S", "T", "U"].pick_random()
		andy_letters.append(letter)
		labels[i].text = letter
	$Sprite/Label.text = letter
