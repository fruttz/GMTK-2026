extends Sprite2D
var rng = RandomNumberGenerator.new()
var velocity = Vector2(0,0)
var cooldown : float = rng.randf_range(0.5,1)
var charge : float = 0
var v0 : float = 300
var v_bias : float = 5
var alive : bool = true
var caught: bool = false

#Andy dan Suffish bakal inherit kelas ini tapi datanya gw ganti, maybe physicsnya
var letter : String = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"].pick_random()
enum types {MOLA}
var type : int = types.MOLA

func init():
	$Label.text = "[font_size=36]"+letter+"[/font_size]"

func _physics_process(delta: float) -> void:
	charge += delta
	if charge > cooldown:
		velocity += Vector2.from_angle(randf_range(0,2*PI))*v0
		charge = 0
		cooldown = rng.randf_range(1.0, 2.0)
	#Character Physics
	velocity.x -= v_bias
	position += delta*velocity
	velocity = velocity/(exp(delta))
		
func catch(catcher_node):
	set_physics_process(false)
	self.call_deferred("reparent", catcher_node)
	self.set_deferred("position", Vector2(0,0))
	caught = true
		
