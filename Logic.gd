extends Node2D
var deck = ["ac", "ad", "ah", "as", "2c", "2d", "2h", "2s", "3c", "3d", "3h", "3s", "4c", "4d", "4h", "4s", "5c", "5d", "5h", "5s", "6c", "6d", "6h", "6s", "7c", "7d", "7h", "7s", "8c", "8d", "8h", "8s", "9c", "9d", "9h", "9s", "10c", "10d", "10h", "10s", "jc", "jd", "jh", "js", "qc", "qd", "qh", "qs", "kc", "kd", "kh", "ks"]
var aces = ["ac", "ad", "ah", "as"]
var twos = ["2c", "2d", "2h", "2s"]
var threes = ["3c", "3d", "3h", "3s"]
var fours = ["4c", "4d", "4h", "4s"]
var fives = ["5c", "5d", "5h", "5s"]
var sixes = ["6c", "6d", "6h", "6s"]
var sevens = ["7c", "7d", "7h", "7s"]
var eights = ["8c", "8d", "8h", "8s"]
var nines = ["9c", "9d", "9h", "9s"]
var tens = ["10c", "10d", "10h", "10s", "jc", "jd", "jh", "js", "qc", "qd", "qh", "qs", "kc", "kd", "kh", "ks"]
var current_place = 0
var player1_deck = []
var dealer_deck = []
var player1_decknum = 0
var dealer_decknum = 0
var bet_amount = 0
var chips = 100
@onready var bet_edit = $BetEdit
@onready var bet_text = bet_edit.text
@onready var deal_amount = $DealAmount
@onready var play_amount = $PlayAmount
@onready var chip_amount = $ChipAmount
@onready var hit_button = $Hit
@onready var stand_button = $Stand
const BLACKJACK_PAY = 1.5
const WIN_PAY = 1
const INSURANCE_PAY = 2
const BLACKJACK = 21
const STAND_ON_SOFT_17 = true

func get_card_value(card: String) -> int:
	if aces.has(card):
		return 1
	elif twos.has(card):
		return 2
	elif threes.has(card):
		return 3
	elif fours.has(card):
		return 4
	elif fives.has(card):
		return 5
	elif sixes.has(card):
		return 6
	elif sevens.has(card):
		return 7
	elif eights.has(card):
		return 8
	elif nines.has(card):
		return 9
	elif tens.has(card):
		return 10
	else:
		return 0
		
func deal():
	if current_place > 48:
		deck.shuffle()
	for i in range(4):
		if (i % 2) != 1:
			player1_deck.append(deck[current_place])
		else:
			dealer_deck.append(deck[current_place])
		current_place += 1
	print(player1_deck, dealer_deck)

func dealer_only_deal():
	if current_place > 50:
		return
	dealer_deck.append(deck[current_place])
	current_place += 1
	print(dealer_deck)
	dealer_decknum = 0
	for i in range(dealer_deck.size()):
		dealer_decknum += get_card_value(dealer_deck[i])

# Create a Hand value calculation ( Aces and such) function
func deck_value(playerdeck: Array, dealerdeck: Array):
	player1_decknum = 0
	dealer_decknum = 0
	for i in range(playerdeck.size()):
		player1_decknum += get_card_value(playerdeck[i])
		print(player1_decknum)
	for i in range(dealerdeck.size()):
		dealer_decknum += get_card_value(dealerdeck[i])
		print(dealer_decknum)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	deck.shuffle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_bet_pressed():
	hit_button.disabled = false
	stand_button.disabled = false
	if chips < int(bet_text):
		print("fak u >:(")
		OS.kill(OS.get_process_id())
	player1_deck.clear()
	dealer_deck.clear()
	deal()
	bet_amount = int(bet_text)
	deck_value(player1_deck, dealer_deck)
	deal_amount.text = ("Dealer: " + str(dealer_decknum))
	play_amount.text = ("You: " + str(player1_decknum))

func _on_bet_edit_text_changed(new_text):
	bet_text = new_text

func _on_hit_pressed():
	player1_deck.append(deck[current_place])
	current_place += 1
	deck_value(player1_deck, dealer_deck)
	deal_amount.text = ("Dealer: " + str(dealer_decknum))
	play_amount.text = ("You: " + str(player1_decknum))
	if player1_decknum > 21:
		print("Bust!")
		print(player1_decknum)
		player1_deck.clear()
		dealer_deck.clear()
		play_amount.text = "Bust! You: " + str(player1_decknum)
		chips -= bet_amount
		chip_amount.text = ("Chips: " + str(chips))

func _on_stand_pressed():
	while dealer_decknum < 17:
		dealer_only_deal()
		deal_amount.text = ("Dealer: " + str(dealer_decknum))
		await get_tree().create_timer(0.5).timeout
	if dealer_decknum > 21 or (player1_decknum > dealer_decknum and dealer_decknum > 16):
		hit_button.disabled = true
		stand_button.disabled = true
		deal_amount.text = ("You win! Dealer: " + str(dealer_decknum))
		chips += bet_amount
		print(chips)
		chip_amount.text = ("Chips: " + str(chips))
	elif dealer_decknum > player1_decknum and dealer_decknum > 16:
		hit_button.disabled = true
		stand_button.disabled = true
		deal_amount.text = ("Dealer wins! Dealer: " + str(dealer_decknum))
		chips -= bet_amount
		print(chips)
		chip_amount.text = ("Chips: " + str(chips))
	elif dealer_decknum == player1_decknum:
		hit_button.disabled = true
		stand_button.disabled = true
		deal_amount.text = ("Tie! Dealer: " + str(dealer_decknum))
		chip_amount.text = ("Chips: " + str(chips))
