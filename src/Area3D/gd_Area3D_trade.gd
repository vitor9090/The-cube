extends Area3D
class_name Tradeable

@export var target:StringName
@export var trade:String = ''

@export var destroy_other:bool = true
@export var destroy_self:bool = true

var output = null

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_Body_entered)

func _on_Body_entered(body):
	if body.name == target:
		if trade != '':
			output = load(trade).instantiate()
		output.position = body.position
		get_viewport().get_camera_3d().interacted_object = null
		get_tree().get_current_scene().add_child(output)
		if destroy_other:
			body.queue_free()
		if destroy_self:
			queue_free()
