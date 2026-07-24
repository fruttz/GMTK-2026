extends Node2D

#maxdepth bakal 0, -720, -1440
var depth_tier = 1
var maxdepth = 720
var mindepth = 100

var letter_array : Array[String] = []
var type_array : Array[int] = []
var fish_array : Array[Node] = []

var rng = RandomNumberGenerator.new()

var spawn_cooldown_array: Array[float] = [rng.randf_range(0.5,1),rng.randf_range(0.5,1),rng.randf_range(0.5,1)]
var spawn_charge_array: Array[float] = [0,0,0]

var Mola = preload("res://Scenes/Mola.tscn")

func _physics_process(delta: float) -> void:
	#Horizontal Sub Capping
	if $Submarine.position.x > $BottomRight.position.x:
		$Submarine.position.x = $BottomRight.position.x
	if $Submarine.position.x < $TopLeft.position.x:
		$Submarine.position.x = $TopLeft.position.x
		
	#Vertical Sub Capping
	if $Submarine.position.y > maxdepth * depth_tier:
		$Submarine.position.y = maxdepth * depth_tier
	if $Submarine.position.y < $Sea.position.y:
		$Submarine.position.y = $Sea.position.y
	
	##Vertical Scrolling
	#if $Submarine.position.y > $BottomRight.position.y:
		#$Sea.position.y += $BottomRight.position.y - $Submarine.position.y
		#$Submarine.position.y = $BottomRight.position.y
		#if $Sea.position.y < maxdepth:
			#$Sea.position.y = maxdepth
	#if $Submarine.position.y < $TopLeft.position.y:
		#$Sea.position.y += $TopLeft.position.y - $Submarine.position.y
		#$Submarine.position.y = $TopLeft.position.y
		#if $Sea.position.y > mindepth:
			#$Sea.position.y = mindepth
	
	#Fish Spawning	
	for i in [0,1,2]:
		spawn_charge_array[i] += delta
		if spawn_charge_array[i] > spawn_cooldown_array[i]:
			spawn( get_node("Sea/Spawner"+str(i+1)), i+1)
			spawn_cooldown_array[i] = rng.randf_range(1,2)
			spawn_charge_array[i] = 0
	#Fish Despawning
	for fish in fish_array:
		if fish.position.x < $Sea/Despawner.position.x:
			fish_array.erase(fish)
			fish.queue_free()
	#Fish Vertical Capping
	for fish in fish_array:
		if fish.position.y < $Sea.position.y:
			fish.position.y = $Sea.position.y
		
		
		
		
func store(fish):
	#function untuk nyetor data ikan
	letter_array.append(fish.letter)
	type_array.append(fish.type)
	fish_array.erase(fish)
	fish.queue_free()

func ready():
	spawn($Spawner1, 1)
	spawn($Spawner1, 2)
	spawn($Spawner1, 3)
	spawn($Spawner1, 1)
	spawn($Spawner1, 2)
	spawn($Spawner1, 3)
	spawn($Spawner1, 1)
	spawn($Spawner1, 2)
	spawn($Spawner1, 3)
	
func spawn(Spawner, _mode : int):
	#mola_mode
	var new_mola = Mola.instantiate()
	add_child(new_mola)
	new_mola.position = Spawner.position + Vector2(0, rng.randf_range(-300,300))
	new_mola.init()
	fish_array.append(new_mola)
