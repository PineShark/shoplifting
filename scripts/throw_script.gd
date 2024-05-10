extends Node2D

var position1 = Vector2(0,0)
var position2 = Vector2(0,0)
var mouse_pressed = false
@onready var thrown_scene = preload("res://scenes/thrown_object.tscn")
@onready var guidance_line = $GuidanceLine as Sprite2D

func _process(delta):
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if mouse_pressed == false:
			mouse_pressed = true
			position1 = get_global_mouse_position()
		# draw line 
		guidance_line.visible = true
		position2 = get_global_mouse_position()
		guidance_line.global_position = position1
		guidance_line.rotation = position1.angle_to_point(position2)
		guidance_line.scale.x = position1.distance_to(position2)/250
		if guidance_line.scale.x > 600:
			guidance_line.scale.x = 600
		print(guidance_line.scale.x)
			
	elif mouse_pressed == true:
		mouse_pressed = false
		position2 = get_global_mouse_position()
		launchObject()
		guidance_line.visible = false

func launchObject():
	var angle = position1.angle_to_point(position2)
	var distance = position1.distance_to(position2)/2
	if distance > 600:
		distance = 600
	var thrown_object = thrown_scene.instantiate()
	thrown_object.global_position = position1
	get_tree().root.add_child(thrown_object)
	thrown_object.setParameters(500*distance,angle)
