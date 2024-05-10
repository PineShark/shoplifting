class_name Shop
## Simply holds the tag, as well as the image of itself.
extends Node2D

var tag = "all"

func _set(property, value):
	property = value

func _get(value):
	return value

func setPosition(new_position):
	global_position = new_position
