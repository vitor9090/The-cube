extends CharacterBody3D

@export var speed:int = 20

var _velocity:Vector3 = Vector3.ZERO
var friction:float = 0.9
var shooting_timer = 0
var shooting_timer_max = 0.1

var invincibility = false

func _physics_process(delta):
	var input_vector = Vector2(Input.get_axis("player_move_left", 'player_move_right'), Input.get_axis("player_move_backwards", 'player_move_foward'))
	input_vector = input_vector.normalized()
	
	if Input.is_action_just_pressed('player_action_shoot'):
		var output = load('res://scenes/nodes/sc_Bullet.tscn').instantiate()
		output.position = position
		get_tree().get_current_scene().add_child(output)
		$AudioStreamPlayer.pitch_scale = randf_range(1.35, 1.5)
		$AudioStreamPlayer.play(0.0)
		#shooting_timer = 0
	
	if Input.is_action_pressed("player_action_shoot"):
		if shooting_timer < shooting_timer_max:
			shooting_timer += delta
		else:
			var output = load('res://scenes/nodes/sc_Bullet.tscn').instantiate()
			output.position = position
			get_tree().get_current_scene().add_child(output)
			$AudioStreamPlayer.pitch_scale = randf_range(1.35, 1.5)
			$AudioStreamPlayer.play(0.0)
			shooting_timer = 0
			
	if Input.is_action_just_released('player_action_shoot'):
		shooting_timer = 0
		
	if Input.is_key_pressed(KEY_I) && Input.is_key_pressed(KEY_N) && Input.is_key_pressed(KEY_V):
		if !invincibility:
			$HurtBox.max_damage_taken = 9999
			invincibility = true
	_velocity.z *= friction
	_velocity.x *= friction
	
	_velocity.z += -input_vector.x * speed * delta
	_velocity.x += -input_vector.y * speed * delta
	
	position.z = clamp(position.z, (-1.5 + position.x / 2.5) - 0.5, (1.5 - position.x / 2.5) + 0.5)
	
	rotation.x = lerp(rotation.z, -input_vector.x, 0.5)
	$Thruster.rotation.y = lerp(rotation.z, -input_vector.x, 0.5)
	
	$Thruster.scale = lerp($Thruster.scale, Vector3.ONE + (Vector3.ONE * input_vector.y) / 3, 0.1)
	
	set_velocity(_velocity)
	move_and_slide()
