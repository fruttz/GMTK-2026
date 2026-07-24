extends Node2D

var velocity = Vector2(0,0)
var omega : float = 0
var speed_tier : float = 3

var harpoon_velocity = Vector2(0,0)
var harpoon_range : float = 75
var harpoon_loaded : bool = true
var harpoon_speed_tier : float = 2
var harpoon_range_tier : float = 2
var omega_speed_tier : float = 0.5

var catching : bool = true
var stashing : bool = true
var alive: bool = true

var TOPLEFT = get

func _physics_process(delta: float) -> void:
	#Character Polling Inputs
	if alive:
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
	$SubmarineSprite.rotation += delta*omega*omega_speed_tier
	omega = omega/(exp(delta))

	#Harpoon Control
	if alive and Input.is_action_pressed("launch_harpoon"):
		harpoon_velocity = Vector2(100,0)
	else:
		harpoon_velocity = Vector2(-100,0)
	$SubmarineSprite/Harpoon.position += harpoon_velocity*delta*harpoon_speed_tier
	if $SubmarineSprite/Harpoon.position.x > harpoon_range*harpoon_range_tier:
		$SubmarineSprite/Harpoon.position = Vector2(harpoon_range*harpoon_range_tier,0)
	if 0 > $SubmarineSprite/Harpoon.position.x :
		$SubmarineSprite/Harpoon.position = Vector2(0,0)
		store_fish()

func store_fish():
	#print("storing fish")
	pass

func _on_harpoon_body_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if catching:
		body.get_parent().catch($SubmarineSprite/Harpoon)
		catching = false
	#reparent ke Harpoon 
	
func _on_door_body_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if stashing:
		get_parent().store(body.get_parent())
		catching = true

func die():
	stashing = false
	catching = false
	alive = false
	
func respawn():
	velocity = Vector2(0,0)
	stashing = true
	catching = true
	alive = true
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
