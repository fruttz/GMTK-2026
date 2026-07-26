extends Node2D
var rng = RandomNumberGenerator.new()
var velocity = Vector2(0,0)
var cooldown : float = rng.randf_range(0.5,1)
var charge : float = 0
var v0 : float = 300
var v_bias : float = 5
var alive : bool = true
var caught: bool = false
var omega: float = 1
var is_andies : bool = false
var wait_frame : bool = false

#Andy dan Suffish bakal inherit kelas ini tapi datanya gw ganti, maybe physicsnya
@export var letter : String = [
  "A", "A", "A", "A", "A", "A", "A", "A", "A",
  "B", "B",
  "C", "C",
  "D", "D", "D", "D",
  "E", "E", "E", "E", "E", "E", "E", "E", "E", "E", "E", "E",
  "F", "F",
  "G", "G", "G",
  "H", "H",
  "I", "I", "I", "I", "I", "I", "I", "I", "I",
  "J",
  "K",
  "L", "L", "L", "L",
  "M", "M",
  "N", "N", "N", "N", "N", "N",
  "O", "O", "O", "O", "O", "O", "O", "O",
  "P", "P",
  "Q",
  "R", "R", "R", "R", "R", "R",
  "S", "S", "S", "S",
  "T", "T", "T", "T", "T", "T",
  "U", "U", "U", "U",
  "V", "V",
  "W", "W",
  "X",
  "Y", "Y",
  "Z",
].pick_random()
enum types {LETTA,SUFFISH,ANDY}
@export var type : int = types.LETTA

func init():
	$Sprite/Label.text = letter

func _physics_process(delta: float) -> void:
	if not caught:
		charge += delta
		if charge > cooldown:
			velocity += Vector2.from_angle(randf_range(0,2*PI))*v0
			charge = 0
			cooldown = rng.randf_range(1.0, 2.0)
		#Character Physics
		velocity.x += v_bias
		position += delta*velocity
		velocity = velocity/(exp(delta))
	else:
		rotation += delta*omega
		#jam fix buat reposition
		if not wait_frame:
			wait_frame = true
		else:
			self.position = get_parent().position
		#just fucking update its position again bruh
		
func catch(catcher_node):
	set_global_position(catcher_node.get_node("Area").get_global_position())
	self.call_deferred("reparent", catcher_node)
	caught = true
	
		
