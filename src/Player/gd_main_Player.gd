extends CharacterBody3D

var camera:Camera3D

var _velocity:Vector3 = Vector3.ZERO

@export var speed:float = 10
var ground_friction = 0.1

@export var gravity:float = 0.5
@export var jump_height:float = 10

@onready var stepping_sounds = $SteppingSounds

enum POSITIONAL_STATES{
	ON_GROUND,
	JUMPING,
	FALLING
}

var positional_state = POSITIONAL_STATES.ON_GROUND
var is_crouching:bool = false

func _ready():
	camera = get_viewport().get_camera_3d()

func _physics_process(delta):
	var input_vector:Vector2i = Vector2i(
		Input.get_axis("player_move_left","player_move_right"), 
		Input.get_axis("player_move_foward","player_move_backwards")
	)

	var movement_direction:Vector2 = Vector2(
		input_vector.x * camera.transform.basis.x.x + input_vector.y * camera.transform.basis.z.x,
		input_vector.x * camera.transform.basis.x.z + input_vector.y * camera.transform.basis.z.z
	)
	movement_direction = movement_direction.normalized()
	
	if Input.is_action_pressed('player_action_crouch'):
		is_crouching = true
		$CollisionShape3D.scale.y = 0.5
	else:
		if is_crouching:
			if !$HeightCheck.get_collider():
				$CollisionShape3D.scale.y = 1
	
	match positional_state:
		POSITIONAL_STATES.FALLING:
			_velocity.y -= gravity
			if stepping_sounds.playing:
				stepping_sounds.stop()
		
			if is_on_floor():
				positional_state = POSITIONAL_STATES.ON_GROUND
		POSITIONAL_STATES.ON_GROUND:
			_velocity.y = 0
			if Input.is_action_just_pressed("player_action_jump"):
				_velocity.y += jump_height
				positional_state = POSITIONAL_STATES.JUMPING
			
			if input_vector.length() > 0:
				if stepping_sounds.playing == false:
					stepping_sounds.play(0.0)
			else:
				if stepping_sounds.playing:
					stepping_sounds.stop()
			
			if !is_on_floor():
				positional_state = POSITIONAL_STATES.FALLING
		POSITIONAL_STATES.JUMPING:
			_velocity.y -= gravity
			if stepping_sounds.playing:
				stepping_sounds.stop()
			
			if Input.is_action_just_released("player_action_jump") || _velocity.y == 0:
				_velocity.y *= 0.5
				positional_state = POSITIONAL_STATES.FALLING
				
			if is_on_floor():
				positional_state = POSITIONAL_STATES.ON_GROUND
			
	
	_velocity.x -= _velocity.x * ground_friction
	_velocity.z -= _velocity.z * ground_friction
	
	_velocity += Vector3(movement_direction.x, 0, movement_direction.y) * ground_friction * speed
	
	set_velocity(_velocity)
	set_up_direction(Vector3.UP)
	move_and_slide()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
