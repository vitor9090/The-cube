extends MenuButton

var preferences = PopupMenu.new()

var settings:Array[Dictionary] = [
	{'Name': 'Mute Music', 'Node': MusicLoader, 'Property': 'muted'},
	{'Name': 'Mute Master', 'Node': MusicLoader, 'Property': 'master_muted'},
]

func _ready():
	$AboutWindow.close_requested.connect(_on_window_close)
	
	var popup = get_popup()
	
	popup.add_child(preferences)
	
	for index in range(settings.size()):
		preferences.add_check_item(settings[index]['Name'], index)
	
	popup.id_pressed.connect(_on_popup_pressed)
	preferences.id_pressed.connect(_on_subpopup_pressed)
	preferences.set_name('Preferences')
	
	popup.add_submenu_item('Preferences', 'Preferences', 1)
	
func _on_popup_pressed(id):
	$AudioStreamPlayer.play()
	if id == 0:
		$AboutWindow.visible = true
	
func _on_subpopup_pressed(id):
	$AudioStreamPlayer.play()
	for index in range(settings.size()):
		if id == index:
			if settings[index].get('Node', null) != null:
				settings[index]['Node'].set(settings[index]['Property'], !settings[index]['Node'].get(settings[index]['Property']))
				preferences.set_item_checked(index, settings[index]['Node'].get(settings[index]['Property']))
				
func _on_window_close():
	$AudioStreamPlayer.play()
	$AboutWindow.visible = false
