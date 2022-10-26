extends CSGMesh3D

@export var speed:Vector3 = Vector3.ZERO

func _process(delta):
	var input:float = Input.get_axis("player_move_left", "player_move_right")
	material.uv1_offset += Vector3(delta * speed.x, delta * speed.y, delta * input * speed.z)
