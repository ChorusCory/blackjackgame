extends Label
@onready var lobby = Lobby
@onready var label = $"../Label"
var namearray = Array()
var sillyfunarray = String()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.str(Lobby.players)
func _process(delta):
	namearray.clear()
	for element in Lobby.players:
		var player = Lobby.players.get(element)
		for item in player:
			if item == "name":
				# append here
				namearray.append(player.get(item))
				
	sillyfunarray = str(namearray).replace(",", "\n").replace("[", "").replace("]", "").replace("\"", "")
	#print(str(str(Lobby.players).split(",")).replace(",", "\n"))
	label.text = sillyfunarray
