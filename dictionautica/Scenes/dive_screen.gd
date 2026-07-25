extends Node2D

#maxdepth bakal 0, -720, -1440
var depth_tier :int = 1
var maxdepth = 720 + 100 #ini calon konflik lol, defer ke gw
var mindepth = 100
var oxygen_tier: int = 1
var oxygen: float = 30
var oxygen_max: float = 30
var oxygen_increment: int = 30
var upgrade_increment = 0
var score = 20
var offset_score = 0

var letter_array : Array[String] = []
var type_array : Array[int] = []
var fish_array : Array[Node] = []

var rng = RandomNumberGenerator.new()

var spawn_cooldown_array: Array[float] = [rng.randf_range(0.5,1),rng.randf_range(0.5,1),rng.randf_range(0.5,1)]
var spawn_charge_array: Array[float] = [0,0,0]
var surfacing : bool

var Mola = preload("res://Scenes/Mola.tscn")

signal oxygen_refilled

func _ready() -> void:
	$Inventory.connect("mission1_upgrade", Callable(self, "mission1_upgrade"))
	$Inventory.connect("mission2_upgrade", Callable(self, "mission2_upgrade"))
	$Inventory.connect("mission3_upgrade", Callable(self, "mission3_upgrade"))

#remove keynya di build final, these are debug buttons
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("upgrade_key"):
		if score == 0:
			main_upgrade()
			upgrade_increment += 1
			if upgrade_increment == 1: 
				score = 40 - offset_score
				$UILayer/Score.text = "Letters to Upgrade: " + str(score)
			elif upgrade_increment == 2:
				score = 60 - offset_score
				$UILayer/Score.text = "Letters to Upgrade: " + str(score)
			elif upgrade_increment == 3:
				score = 80 - offset_score
				$UILayer/Score.text = "Letters to Victory: " + str(score)
			elif upgrade_increment == 4:
				upgrade_increment = 0
				score = 20
				$UILayer/Score.text = "Letters to Upgrade: " + str(score)
			offset_score = 0
			oxygen = oxygen_max
	if event.is_action_pressed("suicide_key"):
		submarine_died()
	if event.is_action_pressed("suffocate_key"):
		oxygen = 1
		
func submarine_died():
#Reset Inventory dan respawn submarinenya
	letter_array.clear()
	$Submarine.die()
	print("you dieded")
#note to self: kasih juice lah biar mati kerasa kaya mati

func main_upgrade():
	if depth_tier < 3:
		depth_tier += 1
		maxdepth += 720
	if oxygen_tier < 3:
		oxygen_tier += 1
		oxygen_max += oxygen_increment
	
	
func _physics_process(delta: float) -> void:
	#Horizontal Sub Capping
	if $Submarine.position.x > $BottomRight.position.x:
		$Submarine.position.x = $BottomRight.position.x
	if $Submarine.position.x < $TopLeft.position.x:
		$Submarine.position.x = $TopLeft.position.x
		
	#Vertical Sub Capping, surfacing status, oxygen refill when dead
	if $Submarine.position.y > maxdepth:
		$Submarine.position.y = maxdepth
	if $Submarine.position.y < $Sea.position.y:
		surfacing = true
		$Submarine/Camera2D.position.y -= 200 * delta
		$Submarine.position.y = $Sea.position.y
		if not $Submarine.alive:
			oxygen += delta*20
			if oxygen > oxygen_max:
				$Submarine.respawn()	
	else:
		surfacing = false
	if $Submarine.position.y >= $Submarine/Camera2D.position.y + 360 and not surfacing:
		$Submarine/Camera2D.position.y = 0
	
	#Oxygen Depletion
	if not surfacing and $Inventory.visible == false:
		oxygen-=delta
	if oxygen < 0:
		submarine_died()
	$UILayer/OxygenBar.value = 100.0*oxygen/oxygen_max
	
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
	
	if surfacing:
		$Inventory_Button.disabled = false
	else:
		$Inventory_Button.disabled = true
	
	if score <= 0 and upgrade_increment < 3:
		score = 0
		$UILayer/Score.text = "Press 'U' to Upgrade!"
	elif score <= 0 and upgrade_increment >= 3:
		score = 0
		$UILayer/Score.text = "Press 'U' to Win!"
	
func  _input(event: InputEvent) -> void:
	if event.is_action_pressed("spelling_game"):
		if $Inventory.visible == true:
			$Inventory.visible = false
			$Submarine/Camera2D.make_current()
			oxygen = oxygen_max
		elif surfacing:
			$Inventory.visible = true
			$Inventory/Camera2D.make_current()
			$Inventory.setup(letter_array)
			letter_array.clear()
			

func store(fish):
	#function untuk nyetor data ikan
	letter_array.append(fish.letter)
	type_array.append(fish.type)
	fish_array.erase(fish)
	fish.queue_free()

func mission1_upgrade():
	print("mission1 upgrade")
	$Submarine.speed_tier += 1
	$UILayer/Mission/Mission1.text = "- [s]Spell a word at least 7 letter long[/s]"

func mission2_upgrade():
	print("mission2 upgrade")
	$Submarine.omega_speed_tier += 1
	$UILayer/Mission/Mission2.text = "- [s]Spell a word with adjacent double letters[/s]"

func mission3_upgrade():
	print("mission3 upgrade")
	$Submarine.arm_range_tier += 1
	$UILayer/Mission/Mission3.text = "- [s]Spell a word starting with J,X,Q or Z[/s]"

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
	if not surfacing and $Inventory.visible == false:
		var new_mola = Mola.instantiate()
		add_child(new_mola)
		new_mola.position = Spawner.position + Vector2(0, rng.randf_range(-300,300))
		new_mola.init()
		fish_array.append(new_mola)

func _on_inventory_button_button_down() -> void:
	$Inventory.visible = true
	$Inventory/Camera2D.make_current()
	$Inventory.setup(letter_array)
	letter_array.clear()
