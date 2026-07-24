extends Node2D

#maxdepth bakal 0, -720, -1440
var maxdepth = -1440
var mindepth = 100

var letter_array : Array[String] = []
var type_array : Array[int] = []

func _physics_process(delta: float) -> void:
	#Horizontal Capping
	if $Submarine.position.x > $BottomRight.position.x:
		$Submarine.position.x = $BottomRight.position.x
		
	if $Submarine.position.x < $TopLeft.position.x:
		$Submarine.position.x = $TopLeft.position.x
	
	if $Submarine.position.y > $BottomRight.position.y:
		$Sea.position.y += $BottomRight.position.y - $Submarine.position.y
		$Submarine.position.y = $BottomRight.position.y
		if $Sea.position.y < maxdepth:
			$Sea.position.y = maxdepth
		
	if $Submarine.position.y < $TopLeft.position.y:
		$Sea.position.y += $TopLeft.position.y - $Submarine.position.y
		$Submarine.position.y = $TopLeft.position.y
		if $Sea.position.y > mindepth:
			$Sea.position.y = mindepth
		
func store(fish):
	#function untuk nyetor data ikan
	letter_array.append(fish.letter)
	type_array.append(fish.type)
	fish.queue_free()
	print(letter_array)
	print(type_array)
