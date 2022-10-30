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

enum camera_mode {
	RELEASE,
	DEBUG
}

var current_camera_mode = camera_mode.RELEASE

signal object_interacted
var interacted_object:PSXPhysicsObject = null:
	get: return interacted_object
	set(new_value):
		interacted_object = new_value
		emit_signal('object_interacted', new_value)
var looking_at = null

var selected_object = null
		
func _input(event):
	if event is InputEventMouseMotion:
		if current_camera_mode == camera_mode.DEBUG:
			rotation.x -= event.relative.y * 0.01
			rotation.y -= event.relative.x * 0.01
		
func _physics_process(delta):
	if current_camera_mode == camera_mode.RELEASE:
		time += delta 
		
		var input:float = Input.get_axis("player_move_left", "player_move_right")
		
		rotation.x += + sin(time) * breathing / 8
		rotation.z = lerp(rotation.z, input / 8, 0.1)
		
		if Input.is_key_pressed(KEY_D) && Input.is_key_pressed(KEY_E) && Input.is_key_pressed(KEY_B):
			current_camera_mode = camera_mode.DEBUG 
	else:
		var move_vector:Vector2 = Vector2(
			Input.get_axis("player_move_left", 'player_move_right'),
			Input.get_axis('player_move_foward', 'player_move_backwards'),
		)
		
		position += ((transform.basis.z * move_vector.y) + (transform.basis.x * move_vector.x)) * 2 * delta

		if Input.is_key_pressed(KEY_R) && Input.is_key_pressed(KEY_E) && Input.is_key_pressed(KEY_L):
			current_camera_mode = camera_mode.RELEASE
			print('a')
