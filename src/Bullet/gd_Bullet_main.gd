extends Sprite3D


var bullet_speed = 4
var time:float = -0.5
func _ready():
	pass 

func _process(delta):
	time += delta
	position.x += bullet_speed * time * -delta
	if position.x < -10:
		queue_free()
