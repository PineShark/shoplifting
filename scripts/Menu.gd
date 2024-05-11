extends Node2D

var wave_time = 10.0
var card_hand = []
var mouse_down = false
var selected_card = null
@onready var timeLabel = $timeLabel as Label
@onready var interimMenu = $InterimMenu as Control
@onready var card_scene = preload("res://scenes/cards/card.tscn") as PackedScene
@onready var throw_object_scene = preload("res://scenes/thrown_object.tscn") as PackedScene
@onready var player = $"../.." as Player

func _process(delta):
	timeLabel.text = str(int(wave_time))
	if wave_time <=0:
		get_tree().paused = true
		interimMenu.visible = true
	else:
		wave_time-=delta
	
	if mouse_down: # if mouse already down:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			mouse_down = false
			if selected_card != null:
				selected_card.dropped()
				selected_card.queue_free()
	
	else: # INFO If mouse not already down: Try and place a card
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			mouse_down = true
			# Check which card is selected
			for i in range(card_hand.size()):
				if card_hand[i].getMouseSelected():
					if card_hand[i].getPrice() <= player.getMoney():
						player.subMoney(card_hand[i].getPrice())
						selected_card = card_hand.pop_at(i)
					break

	if selected_card != null:
		selected_card.setPosition(get_global_mouse_position())

func closeMenu():
	interimMenu.visible = false
	get_tree().paused = false
	wave_time = 10

func handPositions():
	var startingPosition = Vector2(0,350)
	for i in range(card_hand.size()):
		card_hand[i].global_position = global_position+startingPosition+(Vector2(100,0)*i)

func _on_pass_button_pressed():
	closeMenu()
	var card:Card = card_scene.instantiate()
	card.setObjects(throw_object_scene,load("res://scenes/butchery.tscn"))
	card_hand.append(card)
	add_child(card)
	handPositions()
