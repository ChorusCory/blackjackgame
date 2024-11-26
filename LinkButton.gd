extends Button

@onready var lobby = Lobby

@onready var label = $"../Label"

func _on_pressed():
	
	print(lobby.create_game())
