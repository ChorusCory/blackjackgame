extends Node2D


@onready var lobby = Lobby


func _on_line_edit_text_submitted(new_text):
	print(lobby.join_game())
	lobby.load_game.rpc("node_2d.tscn")
	pass # Replace with function body.


func _on_button_pressed():
	pass # Replace with function body.


func _on_line_edit_text_changed(new_text):
	pass # Replace with function body.
