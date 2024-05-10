class_name Shop
## Simply holds the tag, as well as the image of itself.
extends Node2D

var tag = "all"
var picked_up = false
var set_down = false

func _set(property, value):
	property = value

func _get(value):
	return value

func setPosition(new_position):
	global_position = new_position

func getPosition():
	return global_position

func placedDown(new_position):
	global_position = new_position
	set_down = true # Make it able to be picked up

func _on_area_2d_body_entered(body):
	if body.get_collision_layer() == 4: # Player
		# disabled if body is Player:
			body.setNearestShop(self)
			print("Player near shop")
