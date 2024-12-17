extends Node2D


@onready var lobby = Lobby
@onready var text = $LineEdit.text
@onready var username = $UserName

func _on_line_edit_text_submitted(new_text):
	lobby.join_game(username.text, new_text)
	lobby.load_game.rpc("node_2d.tscn")
	pass # Replace with function body.


func _on_button_pressed():
	lobby.join_game(username.text, text)
	lobby.load_game.rpc("node_2d.tscn")
	pass # Replace with function body.


func _on_line_edit_text_changed(new_text):
	text = $LineEdit.text
