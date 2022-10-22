extends Camera3D

var combine = preload("res://src/funcs/gd_Combine_main.gd").new()

var time:float = 0
var bobbing:float = 0.1
var breathing = 0.05
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

func _input(event):
	if event is InputEventMouseMotion:
		target_rotation += Vector2(event.relative.y / sensitivity, event.relative.x / sensitivity)
		target_rotation.x = clamp(target_rotation.x, -PI/2.1, PI/2.1)
		
func _physics_process(delta):
	time += delta 
	
	var input:float = Input.get_axis("player_move_left", "player_move_right")
	
	rotation.x = lerp(rotation.x, -target_rotation.x, 0.3) + sin(time) * breathing / 8
	rotation.y = lerp(rotation.y, -target_rotation.y, 0.3)
	rotation.z = lerp(rotation.z, input/50, 0.1)

	position.y = (get_parent().position.y + get_parent().scale.y / 2) + cos(time * breathing_speed) * breathing # + sin(time * bobbing_speed) / bobbing / 2
	position.x = get_parent().position.x #+ sin(time) / bobbing / 100
	position.z = get_parent().position.z
	
	if ray.get_collider() is PSXPhysicsObject:
		looking_at = ray.get_collider()
		if Input.is_action_just_pressed('player_action_interact'):
			interacted_object = ray.get_collider()
		if Input.is_action_just_pressed("player_action_select") && !Input.is_action_pressed('player_action_interact'):
			if ray.get_collider() != selected_object:
				if selected_object == null:
					selected_object = ray.get_collider()
	else:
		looking_at = null
		
	if Input.is_action_just_pressed("player_action_select"):
		if selected_object != null && (looking_at != selected_object && looking_at != null):
			combine.Combine(selected_object, looking_at, get_tree().get_current_scene())
			selected_object == null 
			
	if Input.is_action_just_released('player_action_interact'):
		interacted_object = null
		
	if selected_object != null:
		$Line.visible = true
		if looking_at == null:
			$Line.position = (selected_object.position + (position)) / 2
			$Line/Path.curve.set_point_position(1, $Line.position + Vector3(-position.x + transform.basis.z.x * 2, (-transform.basis.z.y * 2) + position.y - position.y, -position.z + transform.basis.z.z * 2))
			$Line/Path.curve.set_point_position(0, $Line.position + Vector3(-selected_object.position.x, -position.y, -selected_object.position.z))
		else:
			$Line.position = (selected_object.position + looking_at.position) / 2
			$Line/Path.curve.set_point_position(1, $Line.position + Vector3(-looking_at.position.x, -selected_object.scale.y, -looking_at.position.z))
			$Line/Path.curve.set_point_position(0, $Line.position + Vector3(-selected_object.position.x, -selected_object.position.y - looking_at.position.y + 1, -selected_object.position.z))
	else:
		$Line.visible = false
	
	if interacted_object:
		if interacted_object.mass < 40:
			interacted_object.physics = true
			interacted_object.apply_velocity(-(interacted_object.position - position + transform.basis.z * 2) * 20)
			if Input.is_action_just_pressed("player_action_throw"):
				interacted_object.apply_velocity(-transform.basis.z * (500 / interacted_object.mass))
				interacted_object = null
