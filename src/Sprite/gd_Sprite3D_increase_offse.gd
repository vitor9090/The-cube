extends CSGMesh3D


func _process(delta):
	material.uv1_offset += Vector3(delta * 0.02, 0, 0)
