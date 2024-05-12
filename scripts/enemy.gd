class_name Enemy
extends Node2D
var target = Vector2(410,0)
var spawn = Vector2(0,0)
var direction = 0
var stolen_money = false
var being_picked_up = false
var being_thrown = false
var throw_vector:Vector2 = Vector2(0,0)
var starting_height = 0
@onready var player:Player = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func setPlayer(newplayer:Player):
	player = newplayer

func getPosition():
	return global_position

func setPosition(new_position:Vector2):
	global_position = new_position
	spawn = new_position

func setTarget(new_target:Vector2):
	target = new_target

func _process(delta):
	
	if being_picked_up:
		pass
	elif being_thrown:
		global_position+=(throw_vector*delta)
		if global_position.y > starting_height:
			queue_free()
		throw_vector.y += 980*delta
	else:
		var deltax = target.x - global_position.x
		if deltax>0:
			direction = 1 #Right
		else:
			direction = -1 #Left	
		position.x += 600 * delta * direction
		if absf(position.x-target.x) < 50:
			if not stolen_money and player!=null:
				player.subMoney(1)
				stolen_money = true
				setTarget(spawn)
				# If money is stolen, make a break for it
			elif stolen_money and player!=null:
				queue_free()



func _on_pickup_zone_body_entered(body):
	# Checks to see if player is near
	if body.get_collision_layer() == 4:
		if body is Player:
			body.nearest_thing = self
