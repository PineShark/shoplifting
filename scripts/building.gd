class_name Building
extends RigidBody2D
@export var size:int = 1
var shop_array:Array[Shop] = []
var position_array:Array[Vector2] = [Vector2(0,0),Vector2(0,343),Vector2(0,686)] # Holds offset positons

func _init():
	for i in range(size):
		# Populates shop with null values
		shop_array.append(null)

func addShop(shop:Shop):
	# Adds shop to the building, called on collision by thrownobject with building
	var shop_set = false
	for shop_slot in shop_array:
		if shop_slot == null:
			shop_slot = shop
			shop_set = true
			add_child(shop)
			shop.setPosition(global_position+position_array[0])
			break
	
	if not shop_set:
		# Drop shop on the ground
		pass
