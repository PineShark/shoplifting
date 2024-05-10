class_name ThrownObject
extends RigidBody2D

var held_shop = preload("res://scenes/shop.tscn").instantiate()
var force = 0
var angle = 0

func setParameters(new_force,new_angle,shop):
	force = new_force
	angle = new_angle
	held_shop = shop


func _physics_process(delta):
	if force>0:
		apply_central_force(Vector2(1,0).rotated(angle)*force)
		force = 0
	if linear_velocity==Vector2(0,0):
		# Delete self, creating shop in its place
		get_tree().root.add_child(held_shop)
		held_shop.global_position = global_position
		queue_free()

func _on_body_entered(body):
	if body.get_collision_layer() == 2 and body != null:
		# If hit building:
		# check if building full:
		if body.hasSpace():
			body.addShop(held_shop)
			queue_free()
