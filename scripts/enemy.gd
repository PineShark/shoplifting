extends Node2D
var target = Vector2(410,0)
var direction = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var deltax = target.x - global_position.x
	if deltax>0:
		direction = 1 #Right
	else:
		direction = -1 #Left	
	position.x += 60* delta *direction
