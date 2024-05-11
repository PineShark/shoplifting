class_name Customer
extends Node2D
var target_building:Building = null
var spawn = Vector2(0,0)
var direction = 0
var looking_for = "shop" 
@onready var player:Player = null
@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D
var purchase_timer = 1
var purchasing = false
var purchased = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func setCustomerStats(texture:SpriteFrames,tag:String):
	sprite.sprite_frames = texture
	looking_for = tag

func setPlayer(newplayer:Player):
	player = newplayer

func setPosition(new_position:Vector2):
	global_position = new_position
	spawn = new_position

func setTarget(new_target:Building):
	target_building = new_target

func _process(delta):
	
	if not purchasing:
		var deltax = target_building.global_position.x - global_position.x
		if deltax>0:
			direction = 1 #Right
		else:
			direction = -1 #Left	
		position.x += 200 * delta * direction
		if absf(position.x-target_building.global_position.x) < 50:
			purchasing = true
	elif purchased:
		var deltax = spawn.x - global_position.x
		if deltax>0:
			direction = 1 #Right
		else:
			direction = -1 #Left	
		position.x += 200 * delta * direction
		if absf(position.x-spawn.x) < 50:
			queue_free()
	else: # purchasing
		visible = false
		purchase_timer-=delta
		if purchase_timer<=0:
			var money_made = target_building.searchForTag(looking_for)
			player.addMoney(money_made)
			visible = true
			purchased = true
