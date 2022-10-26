extends Sprite3D

var speed = 2

func straight(delta:float, speed:int):
	position += Vector3(speed, 0, 0) * delta

func criss_cross(delta:float, speed:int):
	position.z += cos(position.x * speed) * (sign(position.z) * speed) * delta
	position.x += speed * delta
	
func middle(delta:float, speed:int):
	position.x += speed * delta
	position.z += ((-position.z) + (sign(-position.z) * 10)) * speed * delta
	
func spiral(delta:float, speed:int):
	position.x += speed * delta
	position.y += sin(position.x) * speed * delta
	position.z += cos(position.x) * speed * delta
	
func stairs(delta:float, speed:int):
	position.z += round(sin(position.x)) * speed * delta
	position.x += speed * delta

var bullet_states:Dictionary
var bullet_state = 'criss-cross'

func _ready():
	bullet_states = {
		'straight': {'speed': 2, 'pattern': 'straight'},
		'criss-cross': {'speed': 3, 'pattern': 'criss_cross'},
		'middle': {'speed': 5, 'pattern': 'middle'},
		'spiral': {'speed': 1, 'pattern': 'spiral'},
		'stairs': {'speed': 2, 'pattern': 'stairs'}
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var function = Callable(self, bullet_states[bullet_state]['pattern'])
	function.call(delta, bullet_states[bullet_state]['speed'])
	
	if position.x > get_viewport().get_camera_3d().position.x:
		queue_free()
