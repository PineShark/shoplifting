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

var nearest_shop = null
var held_shop = null 

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
	if held_shop != null:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				if mouse_pressed == false:
					mouse_pressed = true
				# draw line 
				guidance_line.visible = true
				position2 = get_global_mouse_position()
				guidance_line.global_position = global_position
				guidance_line.rotation = global_position.angle_to_point(position2)
				guidance_line.scale.x = global_position.distance_to(position2)/250
				if guidance_line.scale.x > 600:
					guidance_line.scale.x = 600
				print(guidance_line.scale.x)
		elif mouse_pressed == true:
			mouse_pressed = false
			position2 = get_global_mouse_position()
			launchObject()
			guidance_line.visible = false


	# flip the sprite
	if direction >0:
		animated_sprite.flip_h = false
	elif direction <0:
		animated_sprite.flip_h = true
	move_and_slide()

func setNearestShop(shop:Shop):
	# Adds shop as the nearest one
	nearest_shop = shop

func pickupShop(shop:Shop):
	## Function to pick up shop, it removes shop from parent, then adds shop to player.
	shop.get_parent().remove_child(shop) # Removes child from building
	add_child(shop)
	shop.global_position = global_position
	held_shop = shop

func launchObject():
	var angle = global_position.angle_to_point(position2)
	var distance = global_position.distance_to(position2)/2
	if distance > 600:
		distance = 600
	var thrown_object = thrown_scene.instantiate()
	thrown_object.global_position = global_position
	get_tree().root.add_child(thrown_object)
	thrown_object.setParameters(500*distance,angle,held_shop)
	remove_child(held_shop)
	held_shop = null
