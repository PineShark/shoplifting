extends Node2D
var target = Vector2(410,0)
var direction = 0
var stolen_money = false
@onready var player = $"../Player"
@onready var Money_Label = $"../Player/Camera2D/MoneyLabel"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var deltax = target.x - global_position.x
	if deltax>0:
		direction = 1 #Right
	else:
		direction = -1 #Left	
	position.x += 600* delta *direction
	if not stolen_money:
		if position.x-target.x < 25:
			player.add_point()
			Money_Label.text =  str(player.getmoney()) + " money"
			stolen_money = true
	else:
		pass 

