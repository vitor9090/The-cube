extends PSXPhysicsObject

@onready var camera = get_viewport().get_camera_3d()

var selected = true

func _ready():
	camera.object_interacted.connect(_on_object_interacted)

func _on_object_interacted(new_value):
	if new_value == self:
		print(object_velocity.length())
		selected = true

	
func _physics_process(delta):
	apply_physics()
	
	if selected:
		if object_velocity.length() > 15:
			if is_on_ceiling() || is_on_wall() || is_on_floor():
				camera.interacted_object = null
				var key = load("res://scenes/nodes/sc_Key.tscn").instantiate()
				key.position = position
				get_tree().get_current_scene().add_child(key)
				queue_free()
