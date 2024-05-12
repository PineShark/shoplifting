class_name Player
extends CharacterBody2D


const SPEED = 900.0
const JUMP_VELOCITY = -1200.0

var position1 = Vector2(0,0)
var position2 = Vector2(0,0)
var mouse_pressed = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var thrown_scene = preload("res://scenes/thrown_object.tscn")
@onready var guidance_line = $GuidanceLine as Sprite2D
@onready var animated_sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var money_label = $CanvasLayer/HBoxContainer/MoneyLabel as Label

var nearest_thing = null
var held_thing = null 
# money
var money = 100

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta *2
	# Handle getting up / down from platform
	if Input.is_action_pressed("Down"):
		set_collision_mask_value(6,false)
		set_collision_mask_value(9,false)
	else:
		set_collision_mask_value(6,true)
		set_collision_mask_value(9,true)
	
	if velocity.y < 0:
		set_collision_mask_value(9,false)
	elif not Input.is_action_pressed("Down"):
		set_collision_mask_value(9,true)

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_Left", "Move_Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle picking up shop
	if Input.is_action_just_pressed("Grab") and held_thing == null and nearest_thing != null: 
		# Checks correct preconditions: nearby shop, and not holding shop, and button pressed
		animated_sprite.play("grab")
		if global_position.distance_to(nearest_thing.getPosition())<1000: # Checks that shop is in range
			if nearest_thing is Shop:
				pickupShop(nearest_thing)
			elif nearest_thing is Enemy:
				pickupEnemy(nearest_thing)
			
	# Handle throwing
	elif held_thing != null:
		if Input.is_action_just_pressed("Grab"):
			launchObject()


	# flip the sprite
	if direction <0:
		animated_sprite.flip_h = false
	elif direction >0:
		animated_sprite.flip_h = true
	move_and_slide()

func setNearestShop(shop:Shop):
	# Adds shop as the nearest one
	nearest_thing = shop

func pickupShop(shop:Shop):
	## Function to pick up shop, it removes shop from parent, then adds shop to player.
	shop.getPickedUp()
	shop.reparent(self)
	shop.global_position = global_position + Vector2(-250,-350)
	held_thing = shop

func pickupEnemy(enemy:Enemy):
	## Picks up enemy you fucking wank
	nearest_thing.reparent(self)
	nearest_thing.global_position = global_position+Vector2(0,-100)
	nearest_thing.being_picked_up = true
	held_thing = nearest_thing
	nearest_thing = null

func launchObject():
	# Figure out angle and throw object at that angle
	var angle = 0
	if animated_sprite.flip_h == false:
		angle = -5*PI/6
	else:
		angle = -PI/6

	if held_thing is Shop:
		var thrown_object = thrown_scene.instantiate()
		thrown_object.global_position = global_position
		get_tree().root.add_child(thrown_object)
		thrown_object.setParameters(90000,angle,held_thing)
		remove_child(held_thing)
		held_thing = null
	
	elif held_thing is Enemy:
		held_thing.throw_vector = Vector2(1,0).rotated(angle)*1000
		held_thing.starting_height = held_thing.global_position.y
		get_tree().root.reparent(held_thing)
		held_thing.being_picked_up = false
		held_thing.being_thrown = true
		held_thing = null


func getMoneyLabel()->Label:
	return money_label

func addMoney(amount):
	money += amount
	money_label.text = ("Money:"+str(money))

func subMoney(amount):
	money -=amount
	money_label.text = ("Money:"+str(money))

func getMoney():
	return money




func _on_animated_sprite_2d_animation_looped():
	if held_thing != null:
		animated_sprite.play("hold1")
	elif velocity.length()>1:
		animated_sprite.play("run")
	else:
		animated_sprite.play("default")
