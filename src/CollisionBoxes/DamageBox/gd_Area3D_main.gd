extends Area3D
class_name DamageBox

@export var damage:int = 1
@export var destroy_after_damage:bool = false

signal did_damage

func _ready():
	area_entered.connect(_on_DamageBox_area_entered)
	
func _on_DamageBox_area_entered(area):
	if area is HurtBox:
		var output = load('res://scenes/nodes/Particles/sc_Hit.tscn').instantiate()
		output.position = global_position + Vector3(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1), 0)
		output.emitting = true
		get_tree().get_current_scene().add_child(output)
		
		if not area.invincible:
			var sound = load('res://scenes/nodes/Sounds/sc_Hit.tscn').instantiate()
			get_tree().get_current_scene().add_child(sound)
			sound.play()
				
			area.damage_taken += damage
			emit_signal('did_damage')
			if destroy_after_damage:
				get_parent().queue_free()
		else:
			var part = load('res://scenes/nodes/Particles/sc_Smoke.tscn').instantiate()
			part.position = global_position
			part.emitting = true
			get_tree().get_current_scene().add_child(part)

			var sound = load('res://scenes/nodes/Sounds/sc_Ricochet.tscn').instantiate()
			sound.pitch_scale = randf_range(1, 1.5)
			get_tree().get_current_scene().add_child(sound)
