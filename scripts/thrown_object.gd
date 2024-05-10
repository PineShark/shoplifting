extends RigidBody2D

var held_store_scene = null 
var force = 0
var angle = 0

func setParameters(new_force,new_angle):
	force = new_force
	angle = new_angle

func _physics_process(delta):
	if force>0:
		apply_central_force(Vector2(1,0).rotated(angle)*force)
		force = 0
