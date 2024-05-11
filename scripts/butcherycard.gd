extends Card

func _init():
	throw_object_scene = load("res://scenes/thrown_object.tscn")
	shop_object_scene= load("res://scenes/butchery.tscn")
	mouse_selected = false
	price = 5
