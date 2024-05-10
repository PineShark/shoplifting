extends CharacterBody2D


const SPEED = 900.0
const JUMP_VELOCITY = -2400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta *2
	

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_Left", "Move_Right")

#flip the sprite
	#if direction >0:
		#animated_sprite.flip_h = false
	#elif direction <0:
		#animated_sprite.flip_h = true




	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
## handle going through platform  (Need help)
	if Input.is_action_just_pressed("Down") and is_on_floor() and get_collision_mask_value(2):
		set_collision_mask_value(2,1)
	
