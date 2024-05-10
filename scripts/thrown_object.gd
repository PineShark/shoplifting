class_name ThrownObject
extends RigidBody2D

var held_shop_scene = preload("res://scenes/shop.tscn") 
var force = 0
var angle = 0

func setParameters(new_force,new_angle):
	force = new_force
	angle = new_angle

func _physics_process(delta):
	if force>0:
		apply_central_force(Vector2(1,0).rotated(angle)*force)
		force = 0

func _on_body_entered(body):
	if body.get_collision_layer() == 2 and body != null:
		# If hit building:
		body
		body.addShop(held_shop_scene.instantiate())
		queue_free()
