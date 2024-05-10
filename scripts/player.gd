class_name Player
extends CharacterBody2D


const SPEED = 900.0
const JUMP_VELOCITY = -2400.0

var position1 = Vector2(0,0)
var position2 = Vector2(0,0)
var mouse_pressed = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var thrown_scene = preload("res://scenes/thrown_object.tscn")
@onready var guidance_line = $GuidanceLine as Sprite2D
@onready var animated_sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var money_label = $Camera2D/MoneyLabel as Label

var nearest_shop = null
var held_shop = null 
var money = 1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta *2
	# Handle getting up / down from platform
	if Input.is_action_pressed("Down"):

		set_collision_mask_value(6,false)
	else:
		set_collision_mask_value(6,true)

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
	if Input.is_action_just_pressed("Grab") and held_shop == null and nearest_shop != null: 
		# Checks correct preconditions: nearby shop, and not holding shop, and button pressed
		if global_position.distance_to(nearest_shop.getPosition())<1000: # Checks that shop is in range
			pickupShop(nearest_shop)

	# Handle throwing
	elif held_shop != null:
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
	nearest_shop = shop

func pickupShop(shop:Shop):
	## Function to pick up shop, it removes shop from parent, then adds shop to player.
	shop.getPickedUp()
	shop.get_parent().remove_child(shop) # Removes child from building
	add_child(shop)
	shop.global_position = global_position + Vector2(-250,-350)
	held_shop = shop

func launchObject():
	# Figure out angle and throw object at that angle
	var angle = 0
	if animated_sprite.flip_h == false:
		angle = -5*PI/6
	else:
		angle = -PI/6

	var thrown_object = thrown_scene.instantiate()
	thrown_object.global_position = global_position
	get_tree().root.add_child(thrown_object)
	thrown_object.setParameters(90000,angle,held_shop)
	remove_child(held_shop)
	held_shop = null
#money


func getMoneyLabel()->Label:
	return money_label

func addMoney(amount):
	money += amount
	money_label.text = ("Money:"+str(money))

func subMoney(amount):
	money -=amount
	money_label.text = ("Money:"+str(money))

func getmoney():
	return money
