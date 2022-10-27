extends Node3D


var passed_objects:Array = []
@export var second_phase:bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for children in get_children():
		if children.current_phase == children.PHASES.PHASE_2:
			if !children in passed_objects:
				passed_objects.append(children)
			
	if len(passed_objects) == len(get_children()):
		second_phase = true
