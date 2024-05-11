class_name Card
extends Node2D

var throw_object_scene:PackedScene = null
var shop_object_scene:PackedScene = null
var mouse_selected = false
var price = 1
@onready var sprite = $Sprite2D as Sprite2D

func setPosition(new_position):
	global_position = new_position

func setObjects(new_throw_s,new_shop_s):
	throw_object_scene = new_throw_s
	shop_object_scene = new_shop_s

func setTexture(new_texture):
	sprite.texture = new_texture

func getMouseSelected():
	return mouse_selected

func dropped():
	# When dropped by the mouse, create a thrownshop on an area
	var shop:Shop = shop_object_scene.instantiate()
	add_child(shop)
	var thrown_object:ThrownObject = throw_object_scene.instantiate()
	remove_child(shop)
	thrown_object.setParameters(50,PI/2,shop)
	thrown_object.setPosition(global_position)
	get_tree().root.add_child(thrown_object)


func _on_area_2d_mouse_entered():
	mouse_selected = true


func _on_area_2d_mouse_exited():
	mouse_selected = false

func getPrice():
	return price
