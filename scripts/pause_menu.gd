extends Control

func _ready():
	$AnimationPlayer.play("RESET")

# Called when the node enters the scene tree for the first time.
func resume():
	get_tree().paused = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func pause():
	get_tree().paused = true

func testEsc():
	if Input.is_action_just_pressed("Pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused == true:
		resume()


func _on_resume_pressed():
	resume()



func _on_quit_pressed():
	get_tree().quit()

func _process(_delta):
	testEsc()
