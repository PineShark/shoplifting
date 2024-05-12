extends Node2D


func _on_restart_pressed():
	get_tree().change_scene_to_packed(load("res://scenes/gamemap.tscn"))


func _on_quit_pressed():
	get_tree().quit()
	
