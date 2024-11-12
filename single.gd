extends Button


func _on_pressed():
	print("Singleplayer")
	get_tree().change_scene_to_file("res://node_2d.tscn")
