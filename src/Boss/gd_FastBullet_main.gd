extends CharacterBody3D

var player:CharacterBody3D = null
var _velocity:Vector3 = Vector3.ZERO

@onready var wait_timer:Timer = $WaitTimer

var shoot:bool = false
@onready var sparkle_particle = $Sparkle

func _ready():
	for member in get_tree().get_nodes_in_group("player"):
		player = member
		break

func _physics_process(delta):
	if is_instance_valid(player):
		var distance_to_player = Vector2(
			position.x - player.position.x,
			position.z - player.position.z
		)
		
		var angle_to_player = atan2(distance_to_player.x, distance_to_player.y)
		
		sparkle_particle.position = player.position
		
		if position.x > get_viewport().get_camera_3d().position.x + 2:
			queue_free()
		
		if shoot:
			if position.x < player.position.x:
				_velocity *= 0.9
				
				_velocity.x += -sin(angle_to_player)
				_velocity.z += -cos(angle_to_player)
			
			set_velocity(_velocity)
			move_and_slide()


func _on_wait_timer_timeout():
	shoot = true
