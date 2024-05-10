extends Node2D

@onready var bottom_buildings:Array[Building] = [$"../Building",$"../Building2"]
@onready var top_buildings:Array[Building] = [$"../Building3"]

var bottom_spawn_points:Array[Vector2] = [Vector2(0,-225),Vector2(5000,-225)]
var top_spawn_points:Array[Vector2] = [Vector2(0,-1500), Vector2(5000,-1500)]

var enemy_scene =  preload("res://scenes/enemy.tscn") as PackedScene
var spawn_point = Vector2(0,0)
var target = null

@onready var player = $"../Player"

@export var countdowntime = 2.0
var countdowntimer = countdowntime

func _ready():
	print(player.get_class())

func _process(delta):
	countdowntimer-=delta
	if countdowntimer<=0:
		# Spawn customer or enemy
		if randf()>0.5: # random number in range x:{0 < x <= 1}
			# Spawn at bottom
			spawn_point = bottom_spawn_points.pick_random()
			target = bottom_buildings.pick_random()
		else:
			# Spawn at top 
			spawn_point = top_spawn_points.pick_random()
			target = top_buildings.pick_random()

		var enemy:Enemy = enemy_scene.instantiate()
		add_child(enemy)
		enemy.setPosition(spawn_point)
		enemy.setTarget(target.global_position)
		enemy.setPlayer(player)
		countdowntimer = countdowntime
