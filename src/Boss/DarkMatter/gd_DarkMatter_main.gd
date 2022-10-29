extends CharacterBody3D

var timer = 0
var timer_max = 0.2
var kit_spawned:bool = false
@onready var shooting_sound = $Shooting

@export var attack_order:Array[Dictionary] = [
	{'attack': 'straight', 'time': 2, 'rate': 1},
	{'attack': 'criss-cross', 'time': 2, 'rate': 0.2},
	{'attack': 'middle', 'time': 10, 'rate': 0.5},
	{'attack': 'spiral', 'time': 10, 'rate': 0.2},
	{'attack': 'stairs', 'time': 3, 'rate': 0.2}
]

@onready var attack_phase_1:Node = $States/Phase1

@export var attack_order_phase_2:Array[Dictionary] = [
	{'attack': 'up_and_down', 'time': +5, 'rate': 0.5},
	{'attack': 'criss-cross', 'time': 2, 'rate': 0.5},
	{'attack': 'straight', 'time': 2, 'rate': 0.5},
	{'attack': 'straight', 'time': 5, 'rate': 0.5},
	{'attack': 'straight', 'time': 0.5, 'rate': 0.5},
	{'attack': 'follow', 'time': 5, 'rate': 1}
]

var current_attack = 0

@onready var attack_timer = $PatternTimer
@onready var bullet_rate = $BulletRate
enum PHASES {
	PHASE_1,
	PHASE_2
}

@export var current_phase = PHASES.PHASE_1

var start_attacking = false

func _ready():
	$HurtBox.took_damage.connect(_on_damage_taken)

	get_parent().game_has_started.connect(_on_game_start)


func _process(delta):
	if start_attacking:
		match  current_phase:
			PHASES.PHASE_1:
				if $HurtBox.invincible:
					timer = 0
					current_phase = PHASES.PHASE_2
			PHASES.PHASE_2:
				if get_parent().second_phase == true:
					$HurtBox.invincible = false
					attack_order = attack_order_phase_2
				else:
					current_attack = 0

func _on_attack_timer_timeout():
	if current_attack < len(attack_order) - 1:
		current_attack += 1
		attack_timer.wait_time = attack_order[current_attack].get('time', 1)
	else:
		current_attack = 0

func _on_damage_taken(new_value):
	print(new_value)
	$HitSounds.get_children()[randi() % $HitSounds.get_children().size()].play(0.0)

	$MainSprite.modulate = Color(0.5, 0.5, 0.5, 1)

	await get_tree().create_timer(0.2).timeout

	$MainSprite.modulate = Color(0, 0, 0, 1)

	if new_value >= 100:
		if not kit_spawned:
			var output = load("res://scenes/nodes/sc_FixKit.tscn").instantiate()
			output.position = global_position
			get_tree().get_current_scene().add_child(output)
			kit_spawned = true

		$HurtBox.invincible = true
		$MainSprite.modulate = Color(0.5, 0, 0, 1)


func _on_bullet_rate_timeout():
	#if attack_order.size() < current_attack:
		var output = load('res://scenes/nodes/sc_EnemyBullet.tscn').instantiate()
		output.position = global_position
		bullet_rate.wait_time = attack_order[current_attack].get('rate', 0.2)
		output.bullet_state = attack_order[current_attack].get('attack', 'straight')
		get_tree().get_current_scene().add_child(output)
		shooting_sound.play()

func _on_game_start(new_value):
	if new_value == true:
		start_attacking = true
		attack_timer.start()
		bullet_rate.start()
