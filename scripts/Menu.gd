extends Node2D

var wave_time = 10.0
var card_hand = []
var mouse_down = false
var selected_card = null
@onready var timeLabel = $"../../CanvasLayer/HBoxContainer2/timeLabel" as Label
@onready var interimMenu = $"../../CanvasLayer/InterimMenu" as Control
@onready var card_scene = preload("res://scenes/cards/card.tscn") as PackedScene
@onready var throw_object_scene = preload("res://scenes/thrown_object.tscn") as PackedScene
@onready var player = $"../.." as Player
@onready var cardhand_control = $"../../CanvasLayer/CardHand" as Control

var card_scene_array = [
	preload("res://scenes/cards/butcherycard.tscn") as PackedScene,
	preload("res://scenes/cards/toyshopcard.tscn") as PackedScene
	
]


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
				selected_card = null
	
	else: # INFO If mouse not down but was before: Try and grab a card
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			mouse_down = true
			# Check which card is selected
			for i in range(card_hand.size()):
				if card_hand[i].getMouseSelected():
					if card_hand[i].getPrice() <= player.getMoney():
						player.subMoney(card_hand[i].getPrice())
						selected_card = card_hand.pop_at(i)
						selected_card.reparent(self)
						
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
		card_hand[i].global_position = cardhand_control.global_position+(Vector2(100,0)*i)

func _on_pass_button_pressed():
	closeMenu()


func _on_draw_button_pressed():
	if player.getMoney()>=2:
		player.subMoney(2)
		var card:Card = card_scene_array.pick_random().instantiate()
		card_hand.append(card)
		cardhand_control.add_child(card)
		handPositions()

