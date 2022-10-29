extends Node3D


var player:CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	for member in get_tree().get_nodes_in_group("player"):
		player = member

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_instance_valid(player):
		
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file('res://scenes/sc_main.tscn')
	pass
