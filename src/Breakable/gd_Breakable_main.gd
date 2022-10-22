extends Area3D
class_name Breakable

@export var target:StringName

func _ready():
	body_entered.connect(_on_Self_body_entered)
	
func _on_Self_body_entered(body):	if body != get_parent():
		if target != &"public_all":
			if body.name == target:
				get_parent().queue_free()
		else:
			print(body.get_parent().name)
			get_parent().queue_free()
