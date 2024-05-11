extends Button




func _on_pressed():
	get_tree().change_scene_to_packed(load("res://scenes/gamemap.tscn"))


func _on_button_2_pressed():
	get_tree().quit()
