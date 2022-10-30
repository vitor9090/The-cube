extends CharacterBody3D

var timer = 0
var timer_max = 0.2
var kit_spawned:bool = false
@onready var shooting_sound = $Shooting

@onready var attack_timer = $PatternTimer
@onready var bullet_rate = $BulletRate

var start_pos:Vector3 = Vector3.ZERO

enum PHASES {
	PHASE_1,
	PHASE_2
}

enum PHASE1 {
	STRAIGHT,
	WAVE,
	STAIRS,
	SPIRAL
}

enum PHASE2 {
	MISSILE,
	WAVE,
	STAIRS,
	SNIPER
}

var phase = PHASES.PHASE_1
var attack = PHASE1.STRAIGHT

@export var current_phase = PHASES.PHASE_1
var phase_lenght = 0
var phase_duration = 10

var start_attacking = false

func _ready():
	start_pos = position
	$HurtBox.took_damage.connect(_on_damage_taken)
	get_parent().game_has_started.connect(_on_game_start)
	print(get_parent().name)

func _on_bullet_rate_timeout():
	if start_attacking:
		match phase:
			PHASES.PHASE_1:
				match  attack:
					PHASE1.STRAIGHT:
						bullet_rate.wait_time = 0.5
						phase_lenght += 1
						phase_duration = 20
						spawn_bullet('straight')
						position.z += sin(Time.get_unix_time_from_system() * 2) / 4
						if phase_lenght > phase_duration:
							position.z = start_pos.z
							phase_lenght = 0
							attack = PHASE1.WAVE
					PHASE1.WAVE:
						bullet_rate.wait_time = 1
						phase_duration = 10
						phase_lenght += 1
						spawn_bullet('middle')
						spawn_bullet('criss-cross')
						position.x += sin(Time.get_unix_time_from_system() * 2) / 4
						if phase_lenght > phase_duration:
							phase_lenght = 0
							position.x = start_pos.x
							attack = PHASE1.STAIRS
					PHASE1.STAIRS:
						bullet_rate.wait_time = 2
						phase_duration = 10
						phase_lenght += 1
						spawn_bullet('stairs')
						spawn_bullet('criss-cross')
						if phase_lenght > phase_duration:
							phase_lenght = 0
							attack = PHASE1.SPIRAL
					PHASE1.SPIRAL:
						bullet_rate.wait_time = 1
						phase_duration = 10
						phase_lenght += 1
						spawn_bullet('spiral')
						spawn_bullet('straight')
						position.x += sin(Time.get_unix_time_from_system() * 2) / 4
						position.z += cos(Time.get_unix_time_from_system() * 2) / 4
						if phase_lenght > phase_duration:
							phase_lenght = 0
							position.x = start_pos.x
							position.z = start_pos.z
							attack = PHASE1.STRAIGHT
			PHASES.PHASE_2:
				if get_parent().second_phase == true:
					$HurtBox.invincible = false
					match  attack:
						PHASE2.MISSILE:
							bullet_rate.wait_time = 0
							phase_lenght += 1
							phase_duration = 1
							spawn_bullet('missile')
							position.z += sin(Time.get_unix_time_from_system() * 2) / 4
							if phase_lenght > phase_duration:
								position.z = start_pos.z
								phase_lenght = 0
								attack = PHASE2.WAVE
						PHASE2.WAVE:
							bullet_rate.wait_time = 1
							phase_duration = 10
							phase_lenght += 1
							spawn_bullet('criss-cross')
							spawn_bullet('up_and_down')
							position.x += sin(Time.get_unix_time_from_system() * 2) / 4
							if phase_lenght > phase_duration:
								phase_lenght = 0
								position.x = start_pos.x
								attack = PHASE2.STAIRS
						PHASE2.STAIRS:
							bullet_rate.wait_time = 2
							phase_duration = 10
							phase_lenght += 1
							spawn_bullet('stairs')
							spawn_bullet('criss-cross')
							if phase_lenght > phase_duration:
								phase_lenght = 0
								attack = PHASE2.SNIPER
						PHASE2.SNIPER:
							bullet_rate.wait_time = 1
							phase_duration = 10
							phase_lenght += 1
							spawn_bullet('follow')
							if phase_lenght > phase_duration:
								phase_lenght = 0
								position.x = start_pos.x
								position.z = start_pos.z
								attack = PHASE2.MISSILE

				
func spawn_bullet(type):
		var output = load('res://scenes/nodes/sc_EnemyBullet.tscn').instantiate()
		output.position = global_position
		output.bullet_state = type
		get_tree().get_current_scene().add_child(output)
		shooting_sound.play

func _on_damage_taken(new_value):
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

		if phase == PHASES.PHASE_1:
			position = start_pos
			$HurtBox.invincible = true
			phase = PHASES.PHASE_2
		$MainSprite.modulate = Color(0.5, 0, 0, 1)

func _on_game_start(new_value):
	if new_value == true:
		start_attacking = true
		bullet_rate.start()
