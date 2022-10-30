extends Node3D


var objects:Array = []
var passed_objects:Array = []
var defeated_objects:Array = []
var boss_parts:int = 0

@export var second_phase:bool = false
signal game_has_started
@export var game_started:bool = false:
	get: return game_started
	set(new_value):
		game_started = new_value
		emit_signal('game_has_started', new_value)
	
signal boss_has_been_defeated
var boss_defeated = false
		
func _ready():
	position.x = 10
	MusicLoader.speed_song(1)
	$UI/CenterContainer/Countdown.texture.current_frame = 0
	for item in get_children():
		if item is CharacterBody3D:
			boss_parts += 1
			objects.append(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_started:
		position.y = 10
	
	for children in get_children():
		if children is CharacterBody3D:
			if children.phase == children.PHASES.PHASE_2:
				if !children in passed_objects:
					passed_objects.append(children)
					
	for item in objects:
		print(objects.size())
		if not is_instance_valid(item):
			objects.erase(item)
				
		print(defeated_objects)
		if objects.size() == 0:
			boss_defeated = true
			emit_signal("boss_has_been_defeated", boss_defeated)
			
	if len(passed_objects) == boss_parts:
		second_phase = true
		MusicLoader.speed_song(1.2)


func _on_countdown_timeout():
	game_started = true
	$UI/CenterContainer/Countdown.visible = false
	
	MusicLoader.play_song('MainSong')
	print('game_start')
