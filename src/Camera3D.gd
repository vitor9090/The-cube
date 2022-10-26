extends Camera3D

var combine = preload("res://src/funcs/gd_Combine_main.gd").new()

var time:float = 0
var bobbing:float = 0.1
var breathing = 0.002
var breathing_speed = 2
var bobbing_speed:int = 15

var sensitivity = 100

@onready var ray = $RayCast3D

var target_rotation:Vector2 = Vector2.ZERO

signal object_interacted
var interacted_object:PSXPhysicsObject = null:
	get: return interacted_object
	set(new_value):
		interacted_object = new_value
		emit_signal('object_interacted', new_value)
var looking_at = null

var selected_object = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_as_top_level(true)
		
func _physics_process(delta):
	time += delta 
	
	var input:float = Input.get_axis("player_move_left", "player_move_right")
	
	rotation.x += + sin(time) * breathing / 8
	rotation.z = lerp(rotation.z, input / 8, 0.1)
