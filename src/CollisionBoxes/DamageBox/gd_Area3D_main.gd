extends Area3D
class_name DamageBox

@export var damage:int = 1
@export var destroy_after_damage:bool = false

func _ready():
	area_entered.connect(_on_DamageBox_area_entered)
	
func _on_DamageBox_area_entered(area):
	if area is HurtBox:
		area.damage_taken += damage
		var output = load('res://scenes/nodes/Particles/sc_Hit.tscn').instantiate()
		output.position = global_position + Vector3(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1), 0)
		output.emitting = true
		get_tree().get_current_scene().add_child(output)
		if destroy_after_damage:
			get_parent().queue_free()
