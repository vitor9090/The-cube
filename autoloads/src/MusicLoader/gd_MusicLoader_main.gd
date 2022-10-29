extends Node

var audio_paths:Dictionary = {
	'MainSong': 'res://data/sounds/ha(1).mp3',
}

func _ready():
	print(audio_paths['MainSong'])
	
func play_song(song_name) -> void:
	if $Song.stream != load(audio_paths.get(song_name, 'MainSong')):
		$Song.stream = load(audio_paths.get(song_name, 'MainSong'))
	if !$Song.playing:
		$Song.play()
