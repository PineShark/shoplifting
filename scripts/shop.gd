class_name Shop
## Simply holds the tag, as well as the image of itself.
extends Node2D

var tag = "shop"
var picked_up = false
var set_down = false
var building:Building = null
var earnings = 1
@onready var sprite = $Sprite2D

func _set(property, value):
	property = value

func _get(value):
	return value

func setPosition(new_position):
	global_position = new_position

func getPosition():
	return global_position

func placedDown(new_position,owner_building = null):
	global_position = new_position
	building = owner_building 
	set_down = true # Make it able to be picked up

func getSprite():
	return sprite.texture

func getPickedUp():
	if building!=null:
		building.removeShop(self)

func _on_area_2d_body_entered(body):
	if body.get_collision_layer() == 4: # Player
		# disabled if body is Player:
			body.setNearestShop(self)
