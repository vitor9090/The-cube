extends Node

@onready var phase_lenght = $Lenght

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	

func _on_lenght_timeout():
	set_process(false)

func _on_rate_timeout():
	var output = load('res://scenes/nodes/sc_EnemyBullet.tscn').instantiate()
	output.position = global_position
	bullet_rate.wait_time = attack_order[current_attack].get('rate', 0.2)
	output.bullet_state = attack_order[current_attack].get('attack', 'straight')
	attack_timer.wait_time = attack_order[current_attack].get('time', 1)
	get_tree().get_current_scene().add_child(output)
	shooting_sound.play()
