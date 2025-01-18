extends Button

@onready var lobby = Lobby

@onready var label = $"../Label"

func _on_pressed():
	lobby.create_game()
	$"../LinkButton".set_visible(false)
	$"../StartButton".set_visible(true)
