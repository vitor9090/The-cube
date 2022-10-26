extends CPUParticles3D

func _process(delta):
	var input = Input.get_axis("player_move_left","player_move_right")
	
	gravity.z = input * 4
