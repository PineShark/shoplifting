extends Node2D

var wave_time = 10.0
var card_hand = []
var mouse_down = false
var selected_card = null
var wave = 0
var wave_tax = [10,15,20,30,40,50,75,100]
var not_changed_money_yet = false
@onready var timeLabel = $"../../CanvasLayer/HBoxContainer2/timeLabel" as Label
@onready var rentLabel = $"../../CanvasLayer/HBoxContainer/RentLabel" as Label
@onready var waveLabel = $"../../CanvasLayer/HBoxContainer2/WaveLabel" as Label
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
		if player.getMoney()-wave_tax[wave]<0:
			get_tree().change_scene_to_packed(load("res://scenes/start_screen.tscn")) 
		elif not_changed_money_yet:
			player.subMoney(wave_tax[wave])
			not_changed_money_yet = false
			changeWave()
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
	not_changed_money_yet = true

func changeWave():
	wave+=1
	if wave < wave_tax.size():
		rentLabel.text = ("Tax: "+str(wave_tax[wave]))
	else:
		rentLabel.text = ("Tax: "+str(wave_tax.back()))
	waveLabel.text = ("Wave: "+str(wave))

func _on_draw_button_pressed():
	if player.getMoney()>=2:
		player.subMoney(2)
		var card:Card = card_scene_array.pick_random().instantiate()
		card_hand.append(card)
		cardhand_control.add_child(card)
		handPositions()

