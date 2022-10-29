extends MenuButton

var preferences = PopupMenu.new()

var settings:Array[Dictionary] = [
	{'Name': 'Music', 'Value': false},
	{'Name': 'Main Sound', 'Value': false},
	{'Name': 'Enable Cheats', 'Value': false},
]

func _ready():
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
	
func _on_subpopup_pressed(id):
	for index in range(settings.size()):
		if id == index:
			settings[index]['Value'] = !settings[index]['Value'] 
			preferences.set_item_checked(index, settings[index]['Value'])
