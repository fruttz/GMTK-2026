extends Node2D

#maxdepth bakal 0, -720, -1440
var depth_tier :int = 1
var maxdepth = 720 + 100 #ini calon konflik lol, defer ke gw
var mindepth = 100
var oxygen_tier: int = 1
var oxygen: float = 20
var oxygen_max: int = 20
var oxygen_increment: int = 20
var upgrade_increment = 0
var score = 10
var offset_score = 0

var letter_array : Array[String] = []
var type_array : Array[int] = []
var fish_array : Array[Node] = []

var rng = RandomNumberGenerator.new()

var spawn_cooldown_array: Array[float] = [rng.randf_range(0.5,1),rng.randf_range(0.5,1),rng.randf_range(0.5,1)]
var spawn_charge_array: Array[float] = [0,0,0]
var surfacing : bool

var Letta = preload("res://Scenes/Letta.tscn")
var Suffish = preload("res://Scenes/Suffish.tscn")
var Andies = preload("res://Scenes/Andies.tscn")

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
				score = 20 - offset_score
				$UILayer/Score.text = "Letters to Upgrade: " + str(score)
			elif upgrade_increment == 2:
				score = 30 - offset_score
				$UILayer/Score.text = "Letters to Upgrade: " + str(score)
			elif upgrade_increment == 3:
				score = 40 - offset_score
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
	if event.is_action_pressed("money_key"):
		$Inventory.set_score(score+1)
		
func submarine_died():
#Reset Inventory dan respawn submarinenya
	letter_array.clear()
	$Submarine.die()
#note to self: kasih juice lah biar mati kerasa kaya mati

func main_upgrade():
	if depth_tier < 3:
		depth_tier += 1
		maxdepth += 720
	if oxygen_tier < 3:
		oxygen_tier += 1
		oxygen_max += oxygen_increment
		$UILayer/Gauge/MaxLabel.text= str(oxygen_max)
	
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
	$UILayer/Gauge/Needle.rotation = deg_to_rad( -120 + 240*oxygen/oxygen_max)
	
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
		if fish.position.x > $Sea/Despawner.position.x:
			fish_array.erase(fish)
			fish.queue_free()
	#Fish Vertical Capping, max 200 dari top
	for fish in fish_array:
		if fish.position.y < $Sea.position.y + 200:
			fish.position.y = $Sea.position.y + 200
	
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
			letter_array.clear()
			$Inventory.clear_letters()
		elif surfacing:
			$Inventory.visible = true
			$Inventory/Camera2D.make_current()
			$Inventory.setup(letter_array)
	  
func mission1_upgrade():
	#print("mission1 upgrade")
	$Submarine.speed_tier += 1
	$UILayer/Mission/Mission1.text = "- [s]Spell a word at least 7 letter long[/s]"
	$UILayer/UpgradePanel.visible = true
	$UILayer/UpgradePanel/Sub_Speed.visible = true
	await get_tree().create_timer(3).timeout
	$UILayer/UpgradePanel.visible = false
	$UILayer/UpgradePanel/Rot_Speed.visible = false


func mission2_upgrade():
	#print("mission2 upgrade")
	$Submarine.omega_speed_tier += 1
	$UILayer/Mission/Mission2.text = "- [s]Spell a word with adjacent double letters[/s]"
	$UILayer/UpgradePanel.visible = true
	$UILayer/UpgradePanel/Rot_Speed.visible = true
	await get_tree().create_timer(3).timeout
	$UILayer/UpgradePanel.visible = false
	$UILayer/UpgradePanel/Rot_Speed.visible = false

func mission3_upgrade():
	#print("mission3 upgrade")
	$Submarine.harpoon_range_tier += 1
	$UILayer/Mission/Mission3.text = "- [s]Spell a word starting with J,X,Q or Z[/s]"
	$UILayer/UpgradePanel.visible = true
	$UILayer/UpgradePanel/Arm_Range.visible = true
	await get_tree().create_timer(3).timeout
	$UILayer/UpgradePanel.visible = false
	$UILayer/UpgradePanel/Rot_Speed.visible = false


func store(fish):
	#function untuk nyetor data ikan, kalo andies beda
	if not fish.is_andies:
		letter_array.append(fish.letter)
		type_array.append(fish.type)
		fish_array.erase(fish)
		fish.queue_free()
	else:
		letter_array += (fish.andy_letters)
		type_array += (fish.andy_types)
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
	#var fish = ["Andies","Andies","Andies"].pick_random()
	var fish = ["Letta","Letta","Letta","Letta","Letta","Suffish","Andies"].pick_random()
	match(fish):
		"Letta":
			if not surfacing and $Inventory.visible == false:
				var new_Letta = Letta.instantiate()
				add_child(new_Letta)
				new_Letta.position = Spawner.position + Vector2(0, rng.randf_range(-300,300))
				new_Letta.init()
				fish_array.append(new_Letta)
		"Suffish":
			if not surfacing and $Inventory.visible == false:
				var new_suffish = Suffish.instantiate()
				add_child(new_suffish)
				new_suffish.position = Spawner.position + Vector2(0, rng.randf_range(-300,300))
				new_suffish.init()
				fish_array.append(new_suffish)
		"Andies":
			if not surfacing and $Inventory.visible == false:
				var new_andies = Andies.instantiate()
				add_child(new_andies)
				new_andies.position = Spawner.position + Vector2(0, rng.randf_range(-300,300))
				new_andies.init()
				fish_array.append(new_andies)

func _on_inventory_button_button_down() -> void:
	$Inventory.visible = true
	$Inventory/Camera2D.make_current()
	$Inventory.setup(letter_array)
	letter_array.clear()
