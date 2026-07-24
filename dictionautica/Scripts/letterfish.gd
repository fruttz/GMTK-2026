extends Sprite2D
var rng = RandomNumberGenerator.new()
var velocity = Vector2(0,0)
var cooldown : float = rng.randf_range(1.0, 2.0)
var charge : float = 0
var v0 : float = 150

func _physics_process(delta: float) -> void:
	charge += delta
	if charge > cooldown:
		velocity += Vector2.from_angle(randf_range(0,2*PI))*v0
		charge = 0
		cooldown = rng.randf_range(1.0, 2.0)
	#Character Physics
	velocity.x -= 1
	position += delta*velocity
	velocity = velocity/(exp(delta))

	
