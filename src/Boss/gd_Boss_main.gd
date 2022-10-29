extends Node3D


var passed_objects:Array = []
@export var second_phase:bool = false
signal game_has_started
@export var game_started:bool = false:
	get: return game_started
	set(new_value):
		game_started = new_value
		emit_signal('game_has_started', new_value)
		
func _ready():
	$UI/CenterContainer/Countdown.texture.current_frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_started:
		position.x = lerp(position.x, -5.0, 0.1)
	
	for children in get_children():
		if children is CharacterBody3D:
			if children.current_phase == children.PHASES.PHASE_2:
				if !children in passed_objects:
					passed_objects.append(children)
			
	if len(passed_objects) == len(get_children()) - 2:
		second_phase = true


func _on_countdown_timeout():
	game_started = true
	$UI/CenterContainer/Countdown.visible = false
	
	MusicLoader.play_song('MainSong')
	print('game_start')
