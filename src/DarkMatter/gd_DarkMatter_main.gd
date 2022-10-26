extends Sprite3D

var timer = 0
var timer_max = 0.2

@export var attack_order:Array[Dictionary] = [
	{'attack': 'straight', 'time': 2},
	{'attack': 'criss-cross', 'time': 2},
	{'attack': 'middle', 'time': 10},
	{'attack': 'spiral', 'time': 10},
	{'attack': 'stairs', 'time': 3}
]
var current_attack = 0

@onready var attack_timer = $AttackTimer

func _ready():
	$HurtBox.took_damage.connect(_on_damage_taken)

func _process(delta):
	if $HurtBox.invincible == false:
		if timer < timer_max:
			timer += delta
		else:
			var output = load('res://scenes/nodes/sc_EnemyBullet.tscn').instantiate()
			output.position = global_position
			output.bullet_state = attack_order[current_attack]['attack']
			attack_timer.wait_time = attack_order[current_attack]['time']
			get_tree().get_current_scene().add_child(output)
			timer = 0


func _on_attack_timer_timeout():
	if current_attack < len(attack_order) - 1:
		current_attack += 1
	else:
		current_attack = 0
		

func _on_damage_taken(new_value):
	# min = 0, max = 100, mini = 0, maxi = 1, new_value
	
	modulate.r = 0.5
	modulate.g = 0.5
	modulate.b = 0.5
	
	await get_tree().create_timer(0.2).timeout
	
	modulate.r = 0
	modulate.g = 0
	modulate.b = 0
	
	if new_value >= 100:
		$HurtBox.invincible = true
		modulate.r = 1
		modulate.g = 0
		modulate.b = 0
	
