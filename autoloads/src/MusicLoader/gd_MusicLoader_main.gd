extends Node

var audio_paths:Dictionary = {
	'MainSong': 'res://data/sounds/ha(1).mp3',
}

@export var muted:bool = false:
	get: return muted
	set(new_value):
		muted = new_value
		if muted == false:
			$Song.volume_db = 0
		else:
			$Song.volume_db = -80
			
var is_song_playing = false
var last_second = 0.0
			
@export var master_muted = false:
	get: return master_muted
	set(new_value):
		master_muted = new_value
		var master_sound = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(master_sound, new_value)

func _ready():
	print(audio_paths['MainSong'])
	if muted == false:
		$Song.volume_db = 0
	else:
		$Song.volume_db = -80

func resume_song():
	last_second = $Song.get_playback_position()
	$Song.stop()
	is_song_playing = false
	
func speed_song(amount):
	$Song.pitch_scale = amount
	
func play_song(song_name) -> void:
	if $Song.stream != load(audio_paths.get(song_name, 'MainSong')):
		$Song.stream = load(audio_paths.get(song_name, 'MainSong'))
	if !$Song.playing:
		print(last_second)
		$Song.play(last_second)
		is_song_playing = true
