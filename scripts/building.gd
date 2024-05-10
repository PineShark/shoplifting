class_name Building
extends RigidBody2D
@export var size:int = 1
var shop_array:Array[Shop] = []
var position_array:Array[Vector2] = [Vector2(0,0),Vector2(0,343),Vector2(0,686)] # Holds offset positons

func _ready():
	for i in range(size):
		# Populates shop with null values
		shop_array.append(null)

func hasSpace():
	for shop in shop_array:
		if shop == null:
			return true
	return false

func addShop(shop:Shop):
	# Adds shop to the building, called on collision by thrownobject with building
	var shop_set = false
	for i in range(shop_array.size()):
		if shop_array[i] == null:
			shop_array[i] = shop
			shop_set = true
			add_child(shop)
			shop.placedDown(global_position+position_array[i],self)
			break


func searchForTag(tag:String):
	for shop in shop_array:
		if shop != null:
			if shop.tag == tag:
				return shop.earnings
		return 0


func removeShop(shop:Shop):
	for i in range(shop_array.size()):
		if shop_array[i] == shop:
			shop_array[i] = null
			break
