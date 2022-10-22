extends Node

var crafting_recipes:Array = [
	{'items': [&'Stick', &'Broken_Tile'], 'output': 'res://scenes/nodes/sc_Axe.tscn'},
	{'items': [&'Broken_Key1', &'Broken_Key2'], 'output': 'res://scenes/nodes/Items/sc_Key.tscn'}
]

func Combine(item1, item2, scene):
	for recipe in crafting_recipes:
		if item1.name in recipe['items'] && item2.name in recipe['items']:
			var output = load(recipe['output']).instantiate()
			scene.add_child(output)
			output.position = (item1.position + item2.position) / 2
			item1.free()
			item2.free()
			break;
