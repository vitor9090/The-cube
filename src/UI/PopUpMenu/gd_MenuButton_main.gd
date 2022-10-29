extends MenuButton

var open_recent = PopupMenu.new()

var games_lists:Array[String] = [
	"Super Kinematic Bros",
	"Infinite_Sea_Debug_Alpha",
	"Super Sonic Friends",
	"Green Planet",
	"Coke a' Glue Foam",
	"Kaboom!",
]

func _ready():
	var popup = get_popup()
	
	popup.add_child(open_recent)
	
	popup.id_pressed.connect(_on_popup_pressed)
	open_recent.id_pressed.connect(_on_subpopup_pressed)
	
	for i in range(games_lists.size()):
		var item = open_recent.add_item(games_lists[i], i)
		if i != 1:
			open_recent.set_item_disabled(i, true)
	open_recent.set_name('Open Recent')
	
	popup.add_submenu_item('Open Recent', 'Open Recent', 1)
	
func _on_popup_pressed(id):
	$AudioStreamPlayer.play()
	
	if id == 1:
		get_tree().quit(0)
	
func _on_subpopup_pressed(id):
	$AudioStreamPlayer.play()
	if id == 1:
		DisplayServer.window_set_title(open_recent.get_item_text(id))
		get_tree().change_scene_to_file('res://scenes/sc_main.tscn')
