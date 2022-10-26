extends Area3D
class_name HurtBox

@export var invincible = false

signal took_damage
var damage_taken = 0:
	get: return damage_taken
	set(new_value):
		damage_taken = new_value
		emit_signal('took_damage', damage_taken)
		get_viewport().get_camera_3d().get_node('Control').get_node('ProgressBar').value = damage_taken
		if !invincible:
			if damage_taken > max_damage_taken:
				var output = load("res://scenes/nodes/Particles/sc_ExplosionParticles.tscn").instantiate()
				output.position = global_position
				output.emitting = true
				get_tree().get_current_scene().add_child(output)
				get_parent().queue_free()
@export var max_damage_taken = 10
