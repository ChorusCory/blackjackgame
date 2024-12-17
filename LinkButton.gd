extends Button

@onready var lobby = Lobby

@onready var label = $"../Label"

func _on_pressed():
	
	lobby.create_game()
