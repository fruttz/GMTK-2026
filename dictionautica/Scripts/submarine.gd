extends Node2D

var velocity = Vector2(0,0)
var omega : float = 0
var speed_tier : float = 3

var harpoon_velocity = Vector2(0,0)
var harpoon_range : float = 75
var harpoon_loaded : bool = true
var harpoon_speed_tier : float = 6
var harpoon_range_tier : float = 2
var omega_speed_tier : float = 0.5

var catching : bool = true
var stashing : bool = true
var alive: bool = true

func _physics_process(delta: float) -> void:
	#Character Polling Inputs
	if alive:
		if $"../Inventory".visible == false:
			if Input.is_action_pressed("move_up"):
				velocity += Vector2(0,-100)*delta*speed_tier
			if Input.is_action_pressed("move_down"):
				velocity += Vector2(0,+100)*delta*speed_tier
			if Input.is_action_pressed("move_left"):
				velocity += Vector2(-100,0)*delta*speed_tier
			if Input.is_action_pressed("move_right"):
				velocity += Vector2(+100,0)*delta*speed_tier
			if Input.is_action_pressed("rotate_plus"):
				omega += 5*delta
			if Input.is_action_pressed("rotate_minus"):
				omega -= 5*delta
	else:
		velocity = Vector2(0,-300)
		
	#Character Physics
	position += delta*velocity
	velocity = velocity/(exp(delta))
	$SubRotator.rotation += delta*omega*omega_speed_tier
	omega = omega/(exp(delta))

	#Harpoon Control
	if alive and Input.is_action_pressed("launch_harpoon"):
		harpoon_velocity = Vector2(-50,0)
	else:
		harpoon_velocity = Vector2(50,0)
	$SubRotator/Harpoon.position += harpoon_velocity*delta*harpoon_speed_tier
	if $SubRotator/Harpoon.position.x < -harpoon_range*harpoon_range_tier:
		$SubRotator/Harpoon.position.x = -harpoon_range*harpoon_range_tier
		#harpoon memanjang ke kiri jadinya minus lol
	if -12 < $SubRotator/Harpoon.position.x :
		$SubRotator/Harpoon.position.x = -12
		#print("limit guard")
		store_fish()
	#Harpoon Cable
	$SubRotator/HandChain.scale.x = ($SubRotator/HandGuard.position.x - $SubRotator/Harpoon.position.x)/76
	
func store_fish():
	#print("storing fish")
	pass

func _on_harpoon_body_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if catching and $SubRotator/Harpoon.get_child_count() == 1:
		body.get_parent().catch($SubRotator/Harpoon)
	#reparent ke Harpoon 
	
func _on_door_body_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if stashing:
		get_parent().store(body.get_parent())

func die():
	stashing = false
	catching = false
	alive = false
	$SubRotator/DeadSprite.visible = true
	$SubRotator/SubmarineSprite.visible = false
	$SubRotator/HandChain.visible = false
	$SubRotator/HandGuard.visible = false
	$SubRotator/Harpoon.visible = false
	$DeadPanel.visible = true
	
func respawn():
	position.y = 0
	velocity = Vector2(0,-10)
	stashing = true
	catching = true
	alive = true
	$SubRotator/DeadSprite.visible = false
	$SubRotator/SubmarineSprite.visible = true
	$SubRotator/HandChain.visible = true
	$SubRotator/HandGuard.visible = true
	$SubRotator/Harpoon.visible = true
	$DeadPanel.visible = false
	
func low():
	#$SubRotator/SubmarineSprite/EmptyTank.visible = true
	#$SubRotator/SubmarineSprite/FullTank.visible = false
	pass
func high():
	#$SubRotator/SubmarineSprite/EmptyTank.visible = false
	#$SubRotator/SubmarineSprite/FullTank.visible = true
	pass
func tank_masking(my_float):
	$SubRotator/SubmarineSprite/FullTank.self_modulate.a = sqrt(my_float)
	print("masking")
	print(my_float)
	
#func _input(event: InputEvent) -> void:
	##Character Event Inputs
	#if event.is_action_pressed("launch_harpoon"):
		#if harpoon_loaded:
			#harpoon_velocity = Vector2(200,0)
			#print("crot")
			#harpoon_loaded = false
		#else:
			#print("brot")

#func _unhandled_input(event):
	#if event is InputEventKey:
		#if event.pressed and event.keycode == KEY_W:
			#velocity += Vector2(0,-30)
		#if event.pressed and event.keycode == KEY_S:
			#velocity += Vector2(0,+30)
		#if event.pressed and event.keycode == KEY_A:
			#velocity += Vector2(-30,0)
			#flip_h = true	
		#if event.pressed and event.keycode == KEY_D:
			#velocity += Vector2(+30,0)
			#flip_h = false
		#if event.pressed and event.keycode == KEY_RIGHT:
			#omega += 0.5
		#if event.pressed and event.keycode == KEY_LEFT:
			#omega -= 0.5
	#
pass # Replace with function body.
