extends Node2D

# Define a deck of cards with their respective values.
var deck = ["ac", "ad", "ah", "as", "2c", "2d", "2h", "2s", "3c", "3d", "3h", "3s", "4c", "4d", "4h", "4s", "5c", "5d", "5h", "5s", "6c", "6d", "6h", "6s", "7c", "7d", "7h", "7s", "8c", "8d", "8h", "8s", "9c", "9d", "9h", "9s", "10c", "10d", "10h", "10s", "jc", "jd", "jh", "js", "qc", "qd", "qh", "qs", "kc", "kd", "kh", "ks"]
var player1_deck = []  # Player's hand
var dealer_deck = []  # Dealer's hand
var current_place = 0  # Index for dealing cards from the deck
var bet_amount = 0  # Amount of money bet by the player
var player_money = 1000  # Player's total money (starting amount)

# Signals to communicate bet placement and player actions
signal bet_placed(amount: int)
signal player_action(action: String)

# Returns the value of a given card as per Blackjack rules.
func get_card_value(card: String) -> int:
	if card.begins_with("a"):  # Ace
		return 1
	elif card.begins_with("2"):
		return 2
	elif card.begins_with("3"):
		return 3
	elif card.begins_with("4"):
		return 4
	elif card.begins_with("5"):
		return 5
	elif card.begins_with("6"):
		return 6
	elif card.begins_with("7"):
		return 7
	elif card.begins_with("8"):
		return 8
	elif card.begins_with("9"):
		return 9
	elif card.begins_with("10") or card.begins_with("j") or card.begins_with("q") or card.begins_with("k"):
		return 10
	else:
		return 0

# Calculates the total value of a hand considering Aces as either 1 or 11.
func deck_value(deck: Array) -> int:
	var value = 0
	var ace_count = 0
	
	for card in deck:
		var card_value = get_card_value(card)
		if card_value == 1:  # Count Aces separately
			ace_count += 1
		else:
			value += card_value
	
	# Calculate the optimal value for Aces (1 or 11) to not exceed 21
	for i in range(ace_count):
		if value + 11 <= 21:
			value += 11
		else:
			value += 1
	
	return value

# Deals cards to the player and dealer from the deck.
func deal():
	if current_place > 48:  # Check if there are enough cards left to deal
		return
	for i in range(4):
		if (i % 2) != 1:
			player1_deck.append(deck[current_place])  # Deal to player
		else:
			dealer_deck.append(deck[current_place])  # Deal to dealer
		current_place += 1
	print("Player's hand:", player1_deck)
	print("Dealer's hand:", dealer_deck)

# Adds a card to the player's hand and checks if the player busts.
func hit(deck: Array, hand: Array) -> void:
	if deck.size() > 0:
		hand.append(deck.pop_front())  # Draw a card from the deck
		print("Updated hand:", hand)
		if deck_value(hand) > 21:  # Check if the player has busted
			print("Busted!")

# Executes the dealer's turn, drawing cards until the dealer's hand value is at least 17.
func dealer_turn():
	while deck_value(dealer_deck) < 17:
		dealer_deck.append(deck.pop_front())  # Draw a card from the deck
		print("Dealer's hand:", dealer_deck)
	
	var dealer_value = deck_value(dealer_deck)
	print("Dealer's final value:", dealer_value)

# Determines the winner based on the final values of the player's and dealer's hands.
func determine_winner():
	var player_value = deck_value(player1_deck)
	var dealer_value = deck_value(dealer_deck)
	
	print("Player value:", player_value)
	print("Dealer value:", dealer_value)
	
	if player_value > 21:  # Player busts
		print("Player busts! Dealer wins.")
	elif dealer_value > 21:  # Dealer busts
		print("Dealer busts! Player wins.")
	elif player_value > dealer_value:  # Player wins
		print("Player wins!")
	elif dealer_value > player_value:  # Dealer wins
		print("Dealer wins!")
	else:  # Tie
		print("It's a tie!")

# Initializes a new round of Blackjack by shuffling the deck, dealing cards, and resetting hands.
func start_new_round():
	deck.shuffle()  # Shuffle the deck
	player1_deck.clear()  # Clear previous hands
	dealer_deck.clear()  # Clear previous hands
	current_place = 0  # Reset the dealing index
	deal()  # Deal new hands
	
	print("Starting new round!")
	print("Player's hand:", player1_deck)
	print("Dealer's hand:", dealer_deck[0])  # Show only one dealer card

# Handles the event when the bet button is pressed, processes the bet, and starts a new round.
func on_bet_button_pressed():
	var bet_edit = $BetEdit  # Reference to the LineEdit node for entering the bet
	if bet_edit.text != "":
		bet_amount = int(bet_edit.text)  # Convert bet text to integer
		if bet_amount <= player_money:  # Check if the player has enough money
			player_money -= bet_amount  # Deduct the bet amount from player's money
			emit_signal("bet_placed", bet_amount)  # Emit signal that a bet was placed
			start_new_round()  # Start a new round with the bet
		else:
			print("Insufficient funds!")  # Print error if bet is more than available money

# Handles the event when the hit button is pressed, draws a card for the player, and checks for a bust.
func on_hit_button_pressed():
	hit(deck, player1_deck)  # Draw a card for the player
	if deck_value(player1_deck) > 21:  # Check if the player has busted
		print("Player busts!")
		# Handle bust scenario, such as ending the round or alerting the player

# Handles the event when the stay button is pressed, completes the dealer's turn, and determines the winner.
func on_stay_button_pressed():
	dealer_turn()  # Complete the dealer's turn
	determine_winner()  # Determine the winner of the round

# Called when the node enters the scene tree for the first time. Initializes the game.
func _ready():
	randomize()  # Seed the random number generator for shuffling
	start_new_round()  # Start the initial round of Blackjack


# https://shorturl.at/qTODW
