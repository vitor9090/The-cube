extends CharacterBody3D

var player = null
@onready var model = $MissileModel

func _ready():
	$HurtBox.took_damage.connect(_on_damage_taken)
	
	for member in get_tree().get_nodes_in_group("player"):
		player = member

func _process(delta):
	if is_instance_valid(player):
		var distance_to_player = Vector2(
			global_position.x - player.position.x,
			global_position.z - player.position.z
		)
		
		var angle_to_player = atan2(distance_to_player.x, distance_to_player.y)
		
		model.rotation.y = angle_to_player - (PI / 2)
		
		position.x += -sin(angle_to_player) * delta
		position.z += -cos(angle_to_player) * delta

func _on_damage_taken(new_value):
	var output = load('res://scenes/nodes/Particles/sc_ExplosionLine.tscn').instantiate()
	output.position = global_position
	output.emitting = true
	
	var sound = load('res://scenes/nodes/Sounds/sc_Explosion.tscn').instantiate()
	sound.play()
	get_tree().get_current_scene().add_child(output)
	if $RayCast3D.is_colliding():
		if $RayCast3D.get_collider() is HurtBox:
			$RayCast3D.get_collider().damage_taken += 20
	queue_free()
