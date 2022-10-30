extends Node3D


var player:CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Boss.boss_has_been_defeated.connect(_on_boss_defeat)
	for member in get_tree().get_nodes_in_group("player"):
		player = member

func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("main_pause"):
			get_tree().paused = !get_tree().paused
			if get_tree().paused == true:
				MusicLoader.resume_song()
			else:
				if MusicLoader.is_song_playing == false:
					MusicLoader.play_song('MainSong')
			if $Boss.game_started == false:
				$Boss/UI/CenterContainer/Countdown.visible = false
				$Boss/Countdown.paused = true
				$Boss.game_started = true
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_instance_valid(player):
		
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file('res://scenes/sc_main.tscn')
		
func _on_boss_defeat(value):
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file('res://scenes/sc_EndScreen.tscn')
	pass
