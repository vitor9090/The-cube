extends CharacterBody3D
class_name PSXPhysicsObject

var object_velocity = Vector3.ZERO
@export var ground_friction:float = 0.1
@export var air_friction:float = 0.05

@export var gravity:float = 0.5
@export_range(0.0, 1.0) var bounciness:float = 1

@export var mass:float = 20

var debounce:bool = false

@onready  var ray:RayCast3D = $RayCast3D
var offset = Vector3.ZERO
var query = PhysicsRayQueryParameters3D.create(global_position, global_position)

enum STATES{
	ON_GROUND,
	ON_AIR
}

var state = STATES.ON_AIR

@export var physics:bool = true :
	get: return physics
	set(new_value):
		physics = new_value
		set_physics_process(new_value)
		object_velocity = Vector3.ZERO
		
func _ready():
	set_physics_process(physics)

func _physics_process(delta):
	apply_physics()
	
func apply_physics():
	var direct_state = get_world_3d().direct_space_state
	var collision_ray = direct_state.intersect_ray(query)
	
	match state:
		STATES.ON_AIR:
			object_velocity.x -= object_velocity.x * air_friction
			object_velocity.z -= object_velocity.z * air_friction
			
			object_velocity.y -= (gravity * (5972 * 44) * mass) / pow(1800, 2)
			
			if is_on_floor():
				object_velocity.y = 0
				state = STATES.ON_GROUND
			
		STATES.ON_GROUND:
			object_velocity.z -= object_velocity.z * ground_friction
			object_velocity.x -= object_velocity.x * ground_friction
			
			if !is_on_floor():
				state = STATES.ON_AIR
	
	query.from = global_position
	query.to = global_position + object_velocity.normalized() * 5
	
	set_velocity(object_velocity)
	set_up_direction(Vector3.UP)
	move_and_slide()
	
	if is_on_wall():
		object_velocity = object_velocity.bounce(get_wall_normal()) * bounciness
	if is_on_ceiling():
		object_velocity *= 0.5
	
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider() is PSXPhysicsObject:
			collision.get_collider().apply_velocity(object_velocity.bounce(get_wall_normal()) * bounciness)
			#object_velocity = -object_velocity.bounce(get_wall_normal())
			
func apply_velocity(force:Vector3 = Vector3.ZERO):
	object_velocity = force
